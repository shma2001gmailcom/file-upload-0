package org.misha.action;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;
import org.misha.form.FileUploadForm;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;

public class FileUploadAction extends Action {

    @Override
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response
    ) throws Exception {
        FileUploadForm fileUploadForm = (FileUploadForm) form;
        FormFile file = fileUploadForm.getFile();
        String filePath = getServlet().getServletContext().getRealPath("/") + "upload";
        System.out.println(filePath);
        File folder = new File(filePath);
        if (!folder.exists()) {
            folder.mkdir();
        }
        if(file == null) {
            return mapping.findForward("success");
        }
        String fileName = file.getFileName();
        if (!("").equals(fileName)) {
            System.out.println("Server path:" + filePath);
            File newFile = new File(filePath, fileName);
            if (!newFile.exists()) {
                FileOutputStream fos = new FileOutputStream(newFile);
                fos.write(file.getFileData());
                fos.flush();
                fos.close();
            }
            request.setAttribute("uploadedFilePath", newFile.getAbsoluteFile());
            request.setAttribute("uploadedFileName", newFile.getName());
        }
        return mapping.findForward("success");
    }
}
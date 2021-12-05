module Hazard_Unit (
    input forward_enable,
    input [3:0] src1,
    input [3:0] src2,
    input [3:0] Exe_Dest,
    input Exe_WB_EN,
    input [3:0] Mem_Dest,
    input Mem_WB_EN,
    input MEM_R_EN_EXE,
    input Two_src,
    input use_src1,
    output reg hazard_Detected
);
 
    always @ (*) begin
        if (forward_enable) begin
            hazard_Detected = MEM_R_EN_EXE && (Exe_Dest == src1 || Exe_Dest == src2);
        end else begin
            hazard_Detected = (Exe_WB_EN && (use_src1 && src1 == Exe_Dest)) ||
                              (Exe_WB_EN && (Two_src  && src2 == Exe_Dest)) ||  
                              (Mem_WB_EN && (use_src1 && Mem_Dest == src1)) || 
                              (Mem_WB_EN && (Two_src  && src2 == Mem_Dest));   
        end
    end
  
endmodule


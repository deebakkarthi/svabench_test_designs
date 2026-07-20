module  omsp_scan_mux (

// OUTPUTs
    data_out,                      // Scan mux data output

// INPUTs
    data_in_scan,                  // Selected data input for scan mode
    data_in_func,                  // Selected data input for functional mode
    scan_mode                      // Scan mode
);

// OUTPUTs
//=========
output              data_out;      // Scan mux data output

// INPUTs
//=========
input               data_in_scan;  // Selected data input for scan mode
input               data_in_func;  // Selected data input for functional mode
input               scan_mode;     // Scan mode


//=============================================================================
// 1)  SCAN MUX
//=============================================================================

assign  data_out  =  scan_mode ? data_in_scan : data_in_func;


endmodule // omsp_scan_mux



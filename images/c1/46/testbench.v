`timescale 1ns/1ps

module vga_cur_cregs_tb;

    // Testbench signals (sequential circuit)
    reg arst_i;
    reg [3:0] cadr_i;
    reg clk_i;
    reg [2:0] hadr_i;
    reg [31:0] hdat_i;
    reg hsel_i;
    reg hwe_i;
    reg rst_i;
    wire [15:0] cdat_o;
    wire hack_o;
    wire [31:0] hdat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vga_cur_cregs dut (
        .arst_i(arst_i),
        .cadr_i(cadr_i),
        .clk_i(clk_i),
        .hadr_i(hadr_i),
        .hdat_i(hdat_i),
        .hsel_i(hsel_i),
        .hwe_i(hwe_i),
        .rst_i(rst_i),
        .cdat_o(cdat_o),
        .hack_o(hack_o),
        .hdat_o(hdat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            arst_i = 0;
            hsel_i = 0;
            hwe_i = 0;
            hadr_i = 0;
            hdat_i = 0;
            cadr_i = 0;
            @(posedge clk_i);
            #1;
            rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Register Write and Read Back");
            reset_dut();


            @(posedge clk_i);
            hsel_i = 1;
            hwe_i = 1;
            hadr_i = 3'd2;
            hdat_i = 32'h12345678;
            @(posedge clk_i);
            #1;
            hsel_i = 0;
            hwe_i = 0;


            @(posedge clk_i);
            hsel_i = 1;
            hwe_i = 0;
            hadr_i = 3'd2;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(16'h5678, 1'b1, 32'h12345678);

        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Cursor Data Output Mapping");
            reset_dut();


            @(posedge clk_i);
            hsel_i = 1;
            hwe_i = 1;
            hadr_i = 3'd5;
            hdat_i = 32'hABCDEF01;
            @(posedge clk_i);
            #1;
            hsel_i = 0;





            cadr_i = 4'd10;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'hEF01, 1'b0, 32'h0);


            cadr_i = 4'd11;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'hABCD, 1'b0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Register Independence");
            reset_dut();


            hsel_i = 1; hwe_i = 1; hadr_i = 3'd0; hdat_i = 32'hAAAA_AAAA;
            @(posedge clk_i); #1;

            hadr_i = 3'd7; hdat_i = 32'h5555_5555;
            @(posedge clk_i); #1;
            hsel_i = 0;


            hsel_i = 1; hwe_i = 0; hadr_i = 3'd0;
            cadr_i = 4'd15;
            @(posedge clk_i); #1;

            #1;


            check_outputs(16'h5555, 1'b1, 32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Synchronous Reset Verification");
            reset_dut();


            hsel_i = 1; hwe_i = 1; hadr_i = 3'd1; hdat_i = 32'hFFFF_FFFF;
            @(posedge clk_i); #1;
            hsel_i = 0;


            rst_i = 1;
            @(posedge clk_i); #1;
            rst_i = 0;


            hsel_i = 1; hwe_i = 0; hadr_i = 3'd1;
            @(posedge clk_i); #1;

            #1;


            check_outputs(16'h0000, 1'b1, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bus Selection Control");
            reset_dut();


            hsel_i = 0; hwe_i = 1; hadr_i = 3'd4; hdat_i = 32'hCAFE_BABE;
            @(posedge clk_i); #1;


            hwe_i = 0; hadr_i = 3'd4;
            @(posedge clk_i); #1;



            #1;




            check_outputs(16'h0000, 1'b0, 32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vga_cur_cregs Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [15:0] expected_cdat_o;
        input expected_hack_o;
        input [31:0] expected_hdat_o;
        begin
            if (expected_cdat_o === (expected_cdat_o ^ cdat_o ^ expected_cdat_o) &&
                expected_hack_o === (expected_hack_o ^ hack_o ^ expected_hack_o) &&
                expected_hdat_o === (expected_hdat_o ^ hdat_o ^ expected_hdat_o)) begin
                $display("PASS");
                $display("  Outputs: cdat_o=%h, hack_o=%b, hdat_o=%h",
                         cdat_o, hack_o, hdat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cdat_o=%h, hack_o=%b, hdat_o=%h",
                         expected_cdat_o, expected_hack_o, expected_hdat_o);
                $display("  Got:      cdat_o=%h, hack_o=%b, hdat_o=%h",
                         cdat_o, hack_o, hdat_o);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,arst_i, cadr_i, clk_i, hadr_i, hdat_i, hsel_i, hwe_i, rst_i, cdat_o, hack_o, hdat_o);
    end

endmodule

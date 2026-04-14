`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] lbidw;
    reg [15:0] ofsw;
    reg [5:0] p0;
    reg [5:0] p1;
    reg [5:0] pw;
    reg we;
    wire [11:0] lbid0;
    wire [11:0] lbid1;
    wire [15:0] ofs0;
    wire [15:0] ofs1;
    wire pc_update_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .lbidw(lbidw),
        .ofsw(ofsw),
        .p0(p0),
        .p1(p1),
        .pw(pw),
        .we(we),
        .lbid0(lbid0),
        .lbid1(lbid1),
        .ofs0(ofs0),
        .ofs1(ofs1),
        .pc_update_req(pc_update_req)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            pw = 0;
            p0 = 0;
            p1 = 0;
            lbidw = 0;
            ofsw = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read Port 0...");
            reset_dut();


            @(posedge clk);
            we = 1; pw = 6'd5; lbidw = 12'hAAA; ofsw = 16'h5555;
            @(posedge clk);
            we = 0;


            p0 = 6'd5;
            @(posedge clk);
            #2;




            #1;





            check_outputs(12'hAAA, 12'h0, 16'h5555, 16'h0, pc_update_req);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Dual Port Read...");
            reset_dut();


            @(posedge clk);
            we = 1; pw = 6'd10; lbidw = 12'hB01; ofsw = 16'hDEAD;
            @(posedge clk);

            we = 1; pw = 6'd20; lbidw = 12'hC02; ofsw = 16'hBEEF;
            @(posedge clk);
            we = 0;


            p0 = 6'd10;
            p1 = 6'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hB01, 12'hC02, 16'hDEAD, 16'hBEEF, pc_update_req);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable Verification...");
            reset_dut();


            @(posedge clk);
            we = 1; pw = 6'd30; lbidw = 12'hFFF; ofsw = 16'hFFFF;
            @(posedge clk);


            we = 0; pw = 6'd30; lbidw = 12'h000; ofsw = 16'h0000;
            @(posedge clk);


            p0 = 6'd30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF, 12'h0, 16'hFFFF, 16'h0, pc_update_req);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Address Checks...");
            reset_dut();


            @(posedge clk);
            we = 1; pw = 6'd0; lbidw = 12'h123; ofsw = 16'h4567;
            @(posedge clk);

            we = 1; pw = 6'd63; lbidw = 12'h89A; ofsw = 16'hBCDE;
            @(posedge clk);
            we = 0;


            p0 = 6'd0;
            p1 = 6'd63;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h123, 12'h89A, 16'h4567, 16'hBCDE, pc_update_req);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [11:0] expected_lbid0;
        input [11:0] expected_lbid1;
        input [15:0] expected_ofs0;
        input [15:0] expected_ofs1;
        input expected_pc_update_req;
        begin
            if (expected_lbid0 === (expected_lbid0 ^ lbid0 ^ expected_lbid0) &&
                expected_lbid1 === (expected_lbid1 ^ lbid1 ^ expected_lbid1) &&
                expected_ofs0 === (expected_ofs0 ^ ofs0 ^ expected_ofs0) &&
                expected_ofs1 === (expected_ofs1 ^ ofs1 ^ expected_ofs1) &&
                expected_pc_update_req === (expected_pc_update_req ^ pc_update_req ^ expected_pc_update_req)) begin
                $display("PASS");
                $display("  Outputs: lbid0=%h, lbid1=%h, ofs0=%h, ofs1=%h, pc_update_req=%b",
                         lbid0, lbid1, ofs0, ofs1, pc_update_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lbid0=%h, lbid1=%h, ofs0=%h, ofs1=%h, pc_update_req=%b",
                         expected_lbid0, expected_lbid1, expected_ofs0, expected_ofs1, expected_pc_update_req);
                $display("  Got:      lbid0=%h, lbid1=%h, ofs0=%h, ofs1=%h, pc_update_req=%b",
                         lbid0, lbid1, ofs0, ofs1, pc_update_req);
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
        $dumpvars(0,clk, lbidw, ofsw, p0, p1, pw, we, lbid0, lbid1, ofs0, ofs1, pc_update_req);
    end

endmodule

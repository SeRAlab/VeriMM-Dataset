`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] req;
    reg rst;
    reg [2:0] sel;
    wire [7:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .sel(sel),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 8'h00;
            sel = 3'b000;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Verification");
            test_num = test_num + 1;
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Request Channel 0 with Select 0");
            test_num = test_num + 1;
            reset_dut();
            req = 8'b00000001;
            sel = 3'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Request Channel 7 with Select 7");
            test_num = test_num + 1;
            reset_dut();
            req = 8'b10000000;
            sel = 3'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'b10000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Request on Channel 5, but Select is 2");
            test_num = test_num + 1;
            reset_dut();
            req = 8'b00100000;
            sel = 3'd2;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'b00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple requests (All channels), Select Channel 3");
            test_num = test_num + 1;
            reset_dut();
            req = 8'b11111111;
            sel = 3'd3;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'b00001000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Change selection from 1 to 4 with continuous requests");
            test_num = test_num + 1;
            reset_dut();
            req = 8'b11111111;
            sel = 3'd1;
            @(posedge clk);
            #2;

            sel = 3'd4;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'b00010000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: No requests active, Select 6");
            test_num = test_num + 1;
            reset_dut();
            req = 8'b00000000;
            sel = 3'd6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Toggle request on selected Channel 2");
            test_num = test_num + 1;
            reset_dut();
            sel = 3'd2;
            req = 8'b00000100;
            @(posedge clk);
            #2;
            req = 8'b00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_grant;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%h",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h",
                         expected_grant);
                $display("  Got:      grant=%h",
                         grant);
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
        $dumpvars(0,clk, req, rst, sel, grant);
    end

endmodule

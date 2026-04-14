`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] req;
    reg sys_clk;
    reg sys_rst;
    wire [2:0] gnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .req(req),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .gnt(gnt)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_rst = 1;
            req = 5'b00000;
            @(negedge sys_clk);
            sys_rst = 0;
            @(negedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single request bit 0 after reset", test_num);
            reset_dut();
            req = 5'b00001;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single request bit 3", test_num);
            reset_dut();
            req = 5'b01000;
            @(posedge sys_clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority rotation from bit 0 to 1", test_num);
            reset_dut();
            req = 5'b00011;
            @(posedge sys_clk); #1;

            if (gnt == 3'd0) begin
                req = 5'b00010;
                @(posedge sys_clk); #1;
                #1;

                check_outputs(3'd1);
            end else begin
                $display("  Warning: Initial grant was not 0, skipping transition check.");
                #1;

                check_outputs(3'd0);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Skipping intermediate inactive requests (0 to 4)", test_num);
            reset_dut();
            req = 5'b10001;
            @(posedge sys_clk); #1;
            if (gnt == 3'd0) begin
                req = 5'b10000;
                @(posedge sys_clk); #1;
                #1;

                check_outputs(3'd4);
            end else begin
                #1;

                check_outputs(3'd0);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around logic (grant 4 then grant 0)", test_num);
            reset_dut();

            req = 5'b10000;
            @(posedge sys_clk); #1;
            if (gnt == 3'd4) begin
                req = 5'b10001;
                @(posedge sys_clk); #1;
                req = 5'b00001;
                @(posedge sys_clk); #1;
                #1;

                check_outputs(3'd0);
            end else begin
                $display("  Error: Could not establish grant 4");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential cycling through bits 1, 2, 3", test_num);
            reset_dut();
            req = 5'b01110;
            @(posedge sys_clk); #1;
            req = 5'b01100; @(posedge sys_clk); #1;
            req = 5'b01000; @(posedge sys_clk); #1;
            #1;

            check_outputs(3'd3);
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
        testcase005();
        testcase006();
        
        
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
        input [2:0] expected_gnt;
        begin
            if (expected_gnt === (expected_gnt ^ gnt ^ expected_gnt)) begin
                $display("PASS");
                $display("  Outputs: gnt=%h",
                         gnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt=%h",
                         expected_gnt);
                $display("  Got:      gnt=%h",
                         gnt);
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
        $dumpvars(0,req, sys_clk, sys_rst, gnt);
    end

endmodule

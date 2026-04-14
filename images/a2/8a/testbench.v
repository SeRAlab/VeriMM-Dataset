`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] SW;
    reg [1:0] Scanning;
    reg clk;
    reg clr;
    reg [31:0] disp_num;
    reg [3:0] dpdot;
    wire [3:0] AN;
    wire [7:0] SEGMENT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .Scanning(Scanning),
        .clk(clk),
        .clr(clr),
        .disp_num(disp_num),
        .dpdot(dpdot),
        .AN(AN),
        .SEGMENT(SEGMENT)
    );
    task testcase001;

        begin
            test_num = 1;
            clr = 1;
            disp_num = 32'h12345678;
            Scanning = 2'b00;
            SW = 2'b00;
            dpdot = 4'b0000;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'b1111, 8'hff);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            clr = 0;
            disp_num = 32'h12345678;
            Scanning = 2'b00;
            SW = 2'b00;
            dpdot = 4'b0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1110, 8'h80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            clr = 0;
            disp_num = 32'h12345678;
            Scanning = 2'b01;
            SW = 2'b00;
            dpdot = 4'b0010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1101, 8'h78);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            clr = 0;
            disp_num = 32'h12345678;
            Scanning = 2'b10;
            SW = 2'b00;
            dpdot = 4'b0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1011, 8'h82);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            clr = 0;
            disp_num = 32'h12345678;
            Scanning = 2'b11;
            SW = 2'b00;
            dpdot = 4'b0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0111, 8'h92);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            clr = 0;
            disp_num = 32'h12345678;
            Scanning = 2'b00;
            SW = 2'b01;
            dpdot = 4'b0000;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'b1110, 8'h99);
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
        input [3:0] expected_AN;
        input [7:0] expected_SEGMENT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AN === (expected_AN ^ AN ^ expected_AN) &&
                expected_SEGMENT === (expected_SEGMENT ^ SEGMENT ^ expected_SEGMENT)) begin
                $display("PASS");
                $display("  Outputs: AN=%h, SEGMENT=%h",
                         AN, SEGMENT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AN=%h, SEGMENT=%h",
                         expected_AN, expected_SEGMENT);
                $display("  Got:      AN=%h, SEGMENT=%h",
                         AN, SEGMENT);
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

endmodule

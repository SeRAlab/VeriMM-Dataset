`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] d0;
    reg [15:0] d1;
    reg [15:0] d2;
    reg [15:0] d3;
    reg [1:0] sel;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Selecting input d0 (sel=00)");
            d0 = 16'hAAAA;
            d1 = 16'hBBBB;
            d2 = 16'hCCCC;
            d3 = 16'hDDDD;
            sel = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Selecting input d1 (sel=01)");
            d0 = 16'h1111;
            d1 = 16'h2222;
            d2 = 16'h3333;
            d3 = 16'h4444;
            sel = 2'b01;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Selecting input d2 (sel=10)");
            d0 = 16'h5555;
            d1 = 16'h6666;
            d2 = 16'h7777;
            d3 = 16'h8888;
            sel = 2'b10;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Selecting input d3 (sel=11)");
            d0 = 16'h9999;
            d1 = 16'h0000;
            d2 = 16'hFFFF;
            d3 = 16'h1234;
            sel = 2'b11;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: All inputs zero, switch select");
            d0 = 16'h0000; d1 = 16'h0000; d2 = 16'h0000; d3 = 16'h0000;
            sel = 2'b10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: All inputs one, switch select");
            d0 = 16'hFFFF; d1 = 16'hFFFF; d2 = 16'hFFFF; d3 = 16'hFFFF;
            sel = 2'b01;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Rotating patterns");
            d0 = 16'h0001; d1 = 16'h0002; d2 = 16'h0004; d3 = 16'h0008;
            sel = 2'b00; #1;
 check_outputs(16'h0001);
            sel = 2'b01; #1;
 check_outputs(16'h0002);
            sel = 2'b10; #1;
 check_outputs(16'h0004);
            sel = 2'b11; #1;
 check_outputs(16'h0008);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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

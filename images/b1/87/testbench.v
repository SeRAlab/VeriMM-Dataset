`timescale 1ns/1ps

module mux4to1_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] d0;
    reg [3:0] d1;
    reg [3:0] d2;
    reg [3:0] d3;
    reg [1:0] sel;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1_4bit dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            d0 = 4'hA; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
            sel = 2'b00;
            #10;
            $display("Test %0d: Select d0 (Pattern 1010)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            d0 = 4'hF; d1 = 4'h5; d2 = 4'hE; d3 = 4'h0;
            sel = 2'b01;
            #10;
            $display("Test %0d: Select d1 (Pattern 0101)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            d0 = 4'h1; d1 = 4'h2; d2 = 4'hC; d3 = 4'h3;
            sel = 2'b10;
            #10;
            $display("Test %0d: Select d2 (Pattern 1100)", test_num);
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            d0 = 4'h8; d1 = 4'h4; d2 = 4'h2; d3 = 4'h9;
            sel = 2'b11;
            #10;
            $display("Test %0d: Select d3 (Pattern 1001)", test_num);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            d0 = 4'hF; d1 = 4'hF; d2 = 4'hF; d3 = 4'hF;
            sel = 2'b00;
            #10;
            $display("Test %0d: All inputs high, select d0", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            d0 = 4'h0; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
            sel = 2'b11;
            #10;
            $display("Test %0d: All inputs low, select d3", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            d0 = 4'h1; d1 = 4'h2; d2 = 4'h3; d3 = 4'h4;
            sel = 2'b01;
            #10;

            d1 = 4'hB;
            #10;
            $display("Test %0d: Dynamic data change on selected input d1", test_num);
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            d0 = 4'h7; d1 = 4'h3; d2 = 4'h5; d3 = 4'h1;

            sel = 2'b00;
            #5;
            sel = 2'b10;
            #10;
            $display("Test %0d: Switching select signal from 00 to 10", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1_4bit Testbench");
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
        input [3:0] expected_y;
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

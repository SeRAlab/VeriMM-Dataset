`timescale 1ns/1ps

module multiplexer_16bit_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in0;
    reg [15:0] in1;
    reg [15:0] in2;
    reg [15:0] in3;
    reg [1:0] sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplexer_16bit_4to1 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (0xAAAA)", test_num);
            in0 = 16'hAAAA;
            in1 = 16'hBBBB;
            in2 = 16'hCCCC;
            in3 = 16'hDDDD;
            sel = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (0xBBBB)", test_num);
            in0 = 16'hAAAA;
            in1 = 16'hBBBB;
            in2 = 16'hCCCC;
            in3 = 16'hDDDD;
            sel = 2'b01;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 (0xCCCC)", test_num);
            in0 = 16'hAAAA;
            in1 = 16'hBBBB;
            in2 = 16'hCCCC;
            in3 = 16'hDDDD;
            sel = 2'b10;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in3 (0xDDDD)", test_num);
            in0 = 16'hAAAA;
            in1 = 16'hBBBB;
            in2 = 16'hCCCC;
            in3 = 16'hDDDD;
            sel = 2'b11;
            #1;

            check_outputs(16'hDDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero, check output", test_num);
            in0 = 16'h0000;
            in1 = 16'h0000;
            in2 = 16'h0000;
            in3 = 16'h0000;
            sel = 2'b10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs FFFF, check output", test_num);
            in0 = 16'hFFFF;
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            in3 = 16'hFFFF;
            sel = 2'b01;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walkthrough selections with unique values", test_num);
            in0 = 16'h1234;
            in1 = 16'h5678;
            in2 = 16'h9ABC;
            in3 = 16'hDEF0;

            sel = 2'b00; #5;
            sel = 2'b11;
            #1;

            check_outputs(16'hDEF0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Changing active input value", test_num);
            in0 = 16'hCAFE;
            in1 = 16'hBABE;
            in2 = 16'hFACE;
            in3 = 16'hDEAD;
            sel = 2'b10;
            #5;
            in2 = 16'hFEED;
            #1;

            check_outputs(16'hFEED);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplexer_16bit_4to1 Testbench");
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

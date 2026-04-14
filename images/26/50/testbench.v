`timescale 1ns/1ps

module mux_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_a;
    reg [15:0] data_b;
    reg select;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_16bit dut (
        .data_a(data_a),
        .data_b(data_b),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A (data_a=16'h1234, data_b=16'h5678, select=0)", test_num);
            data_a = 16'h1234;
            data_b = 16'h5678;
            select = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select B (data_a=16'h1234, data_b=16'h5678, select=1)", test_num);
            data_a = 16'h1234;
            data_b = 16'h5678;
            select = 1'b1;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros vs All Ones, Select A", test_num);
            data_a = 16'h0000;
            data_b = 16'hFFFF;
            select = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros vs All Ones, Select B", test_num);
            data_a = 16'h0000;
            data_b = 16'hFFFF;
            select = 1'b1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Patterns, Select A", test_num);
            data_a = 16'hAAAA;
            data_b = 16'h5555;
            select = 1'b0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Patterns, Select B", test_num);
            data_a = 16'hAAAA;
            data_b = 16'h5555;
            select = 1'b1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB Toggle, Select B", test_num);
            data_a = 16'h0000;
            data_b = 16'h0001;
            select = 1'b1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Toggle, Select A", test_num);
            data_a = 16'h8000;
            data_b = 16'h7FFF;
            select = 1'b0;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_16bit Testbench");
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

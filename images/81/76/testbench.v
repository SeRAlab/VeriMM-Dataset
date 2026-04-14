`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg data0;
    reg data1;
    reg data2;
    reg data3;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data0, input 0", test_num);
            sel = 2'b00;
            data0 = 1'b0;
            data1 = 1'b1;
            data2 = 1'b1;
            data3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data0, input 1", test_num);
            sel = 2'b00;
            data0 = 1'b1;
            data1 = 1'b0;
            data2 = 1'b0;
            data3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data1, input 0", test_num);
            sel = 2'b01;
            data0 = 1'b1;
            data1 = 1'b0;
            data2 = 1'b1;
            data3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data1, input 1", test_num);
            sel = 2'b01;
            data0 = 1'b0;
            data1 = 1'b1;
            data2 = 1'b0;
            data3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data2, input 0", test_num);
            sel = 2'b10;
            data0 = 1'b1;
            data1 = 1'b1;
            data2 = 1'b0;
            data3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data2, input 1", test_num);
            sel = 2'b10;
            data0 = 1'b0;
            data1 = 1'b0;
            data2 = 1'b1;
            data3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data3, input 0", test_num);
            sel = 2'b11;
            data0 = 1'b1;
            data1 = 1'b1;
            data2 = 1'b1;
            data3 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select data3, input 1", test_num);
            sel = 2'b11;
            data0 = 1'b0;
            data1 = 1'b0;
            data2 = 1'b0;
            data3 = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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

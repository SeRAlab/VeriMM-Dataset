`timescale 1ns/1ps

module mux_2to1_enable_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] in1;
    reg [7:0] in2;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_enable dut (
        .enable(enable),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable low (select in1), normal values", test_num);
            enable = 1'b0;
            in1 = 8'hA5;
            in2 = 8'h5A;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable high (select in2), normal values", test_num);
            enable = 1'b1;
            in1 = 8'hA5;
            in2 = 8'h5A;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable low (select in1), all zeros vs all ones", test_num);
            enable = 1'b0;
            in1 = 8'h00;
            in2 = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable high (select in2), all zeros vs all ones", test_num);
            enable = 1'b1;
            in1 = 8'h00;
            in2 = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable low, in1=FF, in2=random", test_num);
            enable = 1'b0;
            in1 = 8'hFF;
            in2 = 8'h3C;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable high, in1=random, in2=00", test_num);
            enable = 1'b1;
            in1 = 8'hC3;
            in2 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data transparency check (in1)", test_num);
            enable = 1'b0;
            in1 = 8'h12;
            in2 = 8'h34;
            #5;
            in1 = 8'h78;
            #1;

            check_outputs(8'h78);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data transparency check (in2)", test_num);
            enable = 1'b1;
            in1 = 8'h12;
            in2 = 8'h34;
            #5;
            in2 = 8'h9A;
            #1;

            check_outputs(8'h9A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_enable Testbench");
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
        input [7:0] expected_out;
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

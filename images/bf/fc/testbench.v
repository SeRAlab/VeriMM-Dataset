`timescale 1ns/1ps

module fulladder_tb;

    // Testbench signals (combinational circuit)
    reg carryin;
    reg [4:0] in1;
    reg [4:0] in2;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fulladder dut (
        .carryin(carryin),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple addition without carryin (0 + 0)", test_num);
            in1 = 5'd0;
            in2 = 5'd0;
            carryin = 1'b0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with carryin (0 + 0 + 1)", test_num);
            in1 = 5'd0;
            in2 = 5'd0;
            carryin = 1'b1;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range values (10 + 5)", test_num);
            in1 = 5'd10;
            in2 = 5'd5;
            carryin = 1'b0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum sum without overflow (15 + 16)", test_num);
            in1 = 5'd15;
            in2 = 5'd16;
            carryin = 1'b0;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow check (31 + 1)", test_num);
            in1 = 5'd31;
            in2 = 5'd1;
            carryin = 1'b0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow check with carryin (31 + 0 + 1)", test_num);
            in1 = 5'd31;
            in2 = 5'd0;
            carryin = 1'b1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones addition (31 + 31 + 1)", test_num);
            in1 = 5'd31;
            in2 = 5'd31;
            carryin = 1'b1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating bits (10 + 21)", test_num);
            in1 = 5'b01010;
            in2 = 5'b10101;
            carryin = 1'b0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry propagation check (15 + 1 + 0)", test_num);
            in1 = 5'd15;
            in2 = 5'd1;
            carryin = 1'b0;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random logic check (18 + 10 + 1)", test_num);
            in1 = 5'd18;
            in2 = 5'd10;
            carryin = 1'b1;
            #1;

            check_outputs(5'd29);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fulladder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [4:0] expected_out;
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

`timescale 1ns/1ps

module full_adder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg cin;
    wire cout;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    full_adder_8bit dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero addition (0 + 0 + 0)", test_num);
            a = 8'h00;
            b = 8'h00;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple addition no carry (10 + 20 + 0)", test_num);
            a = 8'd10;
            b = 8'd20;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition with cin (5 + 5 + 1)", test_num);
            a = 8'd5;
            b = 8'd5;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 8'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum sum without carry-out (127 + 128 + 0)", test_num);
            a = 8'd127;
            b = 8'd128;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Carry-out generation (255 + 1 + 0)", test_num);
            a = 8'hFF;
            b = 8'h01;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Carry-out via cin (255 + 0 + 1)", test_num);
            a = 8'hFF;
            b = 8'h00;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum possible values (255 + 255 + 1)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range values (0x55 + 0xAA + 0)", test_num);
            a = 8'h55;
            b = 8'hAA;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bit overflow at MSB (0x80 + 0x80 + 0)", test_num);
            a = 8'h80;
            b = 8'h80;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bits (0xAA + 0x01 + 1)", test_num);
            a = 8'hAA;
            b = 8'h01;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 8'hAC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("full_adder_8bit Testbench");
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
        input expected_cout;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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

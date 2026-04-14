`timescale 1ns/1ps

module adder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg enable;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_8bit dut (
        .a(a),
        .b(b),
        .enable(enable),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Addition disabled (enable=0)", test_num);
        a = 8'd100;
        b = 8'd50;
        enable = 0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Simple addition (10 + 20)", test_num);
        a = 8'd10;
        b = 8'd20;
        enable = 1;
        #1;

        check_outputs(9'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Zero addition (0 + 0)", test_num);
        a = 8'd0;
        b = 8'd0;
        enable = 1;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Maximum values (255 + 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        enable = 1;
        #1;

        check_outputs(9'h1FE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Carry check (128 + 128)", test_num);
        a = 8'd128;
        b = 8'd128;
        enable = 1;
        #1;

        check_outputs(9'd256);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Large inputs disabled", test_num);
        a = 8'hFF;
        b = 8'hFF;
        enable = 0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Random value addition (123 + 45)", test_num);
        a = 8'd123;
        b = 8'd45;
        enable = 1;
        #1;

        check_outputs(9'd168);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Boundary check (255 + 1)", test_num);
        a = 8'd255;
        b = 8'd1;
        enable = 1;
        #1;

        check_outputs(9'd256);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_8bit Testbench");
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
        input [8:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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

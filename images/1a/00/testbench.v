`timescale 1ns/1ps

module decoder5to32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder5to32 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase001: Input = 00000 (0)");
        in = 5'b00000;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase002: Input = 00001 (1)");
        in = 5'b00001;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase003: Input = 01010 (10)");
        in = 5'b01010;
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase004: Input = 01111 (15)");
        in = 5'b01111;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase005: Input = 10000 (16)");
        in = 5'b10000;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase006: Input = 10101 (21)");
        in = 5'b10101;
        #1;

        check_outputs(32'h00200000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase007: Input = 11110 (30)");
        in = 5'b11110;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase008: Input = 11111 (31)");
        in = 5'b11111;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase009;

    integer i;
    begin
        $display("Testcase009: Exhaustive Sweep (all 32 inputs)");
        for (i = 0; i < 32; i = i + 1) begin
            test_num = 9 + i;
            in = i[4:0];
            #1;

            check_outputs(32'h00000001 << i);
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder5to32 Testbench");
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
        input [31:0] expected_out;
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

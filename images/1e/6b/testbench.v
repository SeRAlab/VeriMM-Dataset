`timescale 1ns/1ps

module encoder_32_to_5_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_32_to_5 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs zero (Expecting 5'b11111)", test_num);
        in = 32'h00000000;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Bit 0 set (Expecting index 0)", test_num);
        in = 32'h00000001;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Bit 31 set (Expecting index 31)", test_num);
        in = 32'h80000000;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Testing index 1, 2, 4, 8, 16", test_num);

        in = 32'h00000002;
        #1;

        check_outputs(5'd1);

        in = 32'h00000004;
        #1;

        check_outputs(5'd2);

        in = 32'h00000010;
        #1;

        check_outputs(5'd4);

        in = 32'h00000100;
        #1;

        check_outputs(5'd8);

        in = 32'h00010000;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Testing arbitrary indices (7, 15, 23)", test_num);

        in = (1 << 7);
        #1;

        check_outputs(5'd7);

        in = (1 << 15);
        #1;

        check_outputs(5'd15);

        in = (1 << 23);
        #1;

        check_outputs(5'd23);
    end
        endtask

    task testcase006;

        integer i;
    begin
        test_num = 6;
        $display("Test %0d: Exhaustive verification (Indices 0 to 31)", test_num);
        for (i = 0; i < 32; i = i + 1) begin
            in = (32'b1 << i);
            #1;

            check_outputs(i[4:0]);
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
        $display("encoder_32_to_5 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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

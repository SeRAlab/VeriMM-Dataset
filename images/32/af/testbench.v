`timescale 1ns/1ps

module encoder32to5_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder32to5 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: No inputs active (All zeros)", test_num);
        in = 32'h0000_0000;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input bit 0 active", test_num);
        in = 32'h0000_0001;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input bit 1 active", test_num);
        in = 32'h0000_0002;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input bit 5 active", test_num);
        in = 32'h0000_0020;
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input bit 10 active", test_num);
        in = 32'h0000_0400;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input bit 15 active", test_num);
        in = 32'h0000_8000;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input bit 24 active", test_num);
        in = 32'h0100_0000;
        #1;

        check_outputs(5'd24);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input bit 31 active", test_num);
        in = 32'h8000_0000;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase009;

        integer i;
        begin
            $display("Testcase 009: Sweeping all 32 inputs...");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = 900 + i;
                in = (32'h0000_0001 << i);
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
        $display("encoder32to5 Testbench");
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

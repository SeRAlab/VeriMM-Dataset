`timescale 1ns/1ps

module priority_encoder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_8bit dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 8'b00000000;
        $display("Testcase %0d: Input = %b (No bits set)", test_num, in);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 8'b00000001;
        $display("Testcase %0d: Input = %b (Bit 0 is highest)", test_num, in);
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 8'b00000010;
        $display("Testcase %0d: Input = %b (Bit 1 is highest)", test_num, in);
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 8'b00000100;
        $display("Testcase %0d: Input = %b (Bit 2 is highest)", test_num, in);
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 8'b00001000;
        $display("Testcase %0d: Input = %b (Bit 3 is highest)", test_num, in);
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 8'b00010000;
        $display("Testcase %0d: Input = %b (Bit 4 is highest)", test_num, in);
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 8'b00100000;
        $display("Testcase %0d: Input = %b (Bit 5 is highest)", test_num, in);
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 8'b01000000;
        $display("Testcase %0d: Input = %b (Bit 6 is highest)", test_num, in);
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 8'b10000000;
        $display("Testcase %0d: Input = %b (Bit 7 is highest)", test_num, in);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 8'b11111111;
        $display("Testcase %0d: Input = %b (All bits set, Bit 7 priority)", test_num, in);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in = 8'b00101010;
        $display("Testcase %0d: Input = %b (Multiple bits, Bit 5 priority)", test_num, in);
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in = 8'b00001111;
        $display("Testcase %0d: Input = %b (Multiple bits, Bit 3 priority)", test_num, in);
        #1;

        check_outputs(3'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_8bit Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_out;
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

`timescale 1ns/1ps

module decoder_9to512_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in;
    wire [511:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_9to512 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        $display("Test Case 001: Minimum input value (0)");
        in = 9'd0;
        #1;

        check_outputs(512'h1 << 0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Maximum input value (511)");
        in = 9'd511;
        #1;

        check_outputs(512'h1 << 511);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Input value 1");
        in = 9'd1;
        #1;

        check_outputs(512'h1 << 1);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Input value 256 (Middle bit 1, others 0)");
        in = 9'd256;
        #1;

        check_outputs(512'h1 << 256);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Input value 255 (Boundary of lower half)");
        in = 9'd255;
        #1;

        check_outputs(512'h1 << 255);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Alternating bit pattern (170)");
        in = 9'd170;
        #1;

        check_outputs(512'h1 << 170);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Alternating bit pattern (85)");
        in = 9'd85;
        #1;

        check_outputs(512'h1 << 85);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Arbitrary value (123)");
        in = 9'd123;
        #1;

        check_outputs(512'h1 << 123);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Arbitrary value (432)");
        in = 9'd432;
        #1;

        check_outputs(512'h1 << 432);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: Power of 2 value (64)");
        in = 9'd64;
        #1;

        check_outputs(512'h1 << 64);
    end
        endtask

    task testcase011;

    begin
        $display("Test Case 011: Input 510");
        in = 9'd510;
        #1;

        check_outputs(512'h1 << 510);
    end
        endtask

    task testcase012;

    begin
        $display("Test Case 012: Input 2");
        in = 9'd2;
        #1;

        check_outputs(512'h1 << 2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_9to512 Testbench");
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
        input [511:0] expected_out;
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

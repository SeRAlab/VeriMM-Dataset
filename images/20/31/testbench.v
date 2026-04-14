`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire active;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .in(in),
        .active(active),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs inactive (Zero Case)", test_num);
        in = 8'b00000000;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Highest priority input active (Bit 7)", test_num);
        in = 8'b10000000;
        #1;

        check_outputs(1'b1, 3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Lowest priority input active (Bit 0)", test_num);
        in = 8'b00000001;
        #1;

        check_outputs(1'b1, 3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range input active (Bit 3)", test_num);
        in = 8'b00001000;
        #1;

        check_outputs(1'b1, 3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority check - Bits 7 and 0 active (7 should win)", test_num);
        in = 8'b10000001;
        #1;

        check_outputs(1'b1, 3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority check - Bits 4, 2, and 1 active (4 should win)", test_num);
        in = 8'b00010110;
        #1;

        check_outputs(1'b1, 3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs active (Bit 7 should win)", test_num);
        in = 8'b11111111;
        #1;

        check_outputs(1'b1, 3'b111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking one - Bit 1", test_num);
        in = 8'b00000010;
        #1;

        check_outputs(1'b1, 3'b001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking one - Bit 2", test_num);
        in = 8'b00000100;
        #1;

        check_outputs(1'b1, 3'b010);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking one - Bit 4", test_num);
        in = 8'b00010000;
        #1;

        check_outputs(1'b1, 3'b100);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking one - Bit 5", test_num);
        in = 8'b00100000;
        #1;

        check_outputs(1'b1, 3'b101);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking one - Bit 6", test_num);
        in = 8'b01000000;
        #1;

        check_outputs(1'b1, 3'b110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder Testbench");
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
        input expected_active;
        input [2:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_active === (expected_active ^ active ^ expected_active) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: active=%b, out=%h",
                         active, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active=%b, out=%h",
                         expected_active, expected_out);
                $display("  Got:      active=%b, out=%h",
                         active, out);
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

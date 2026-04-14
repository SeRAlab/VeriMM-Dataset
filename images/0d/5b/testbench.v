`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dst;
    reg [4:0] dst_allowed;
    reg [4:0] src;
    reg [4:0] src_allowed;
    wire valid_packet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dst(dst),
        .dst_allowed(dst_allowed),
        .src(src),
        .src_allowed(src_allowed),
        .valid_packet(valid_packet)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Perfect Match", test_num);
            src = 5'b01010;
            src_allowed = 5'b01010;
            dst = 5'b10101;
            dst_allowed = 5'b10101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Source Mismatch", test_num);
            src = 5'b00001;
            src_allowed = 5'b00010;
            dst = 5'b11111;
            dst_allowed = 5'b11111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Destination Mismatch", test_num);
            src = 5'b10101;
            src_allowed = 5'b10101;
            dst = 5'b00100;
            dst_allowed = 5'b01000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Both Mismatch", test_num);
            src = 5'b11000;
            src_allowed = 5'b00011;
            dst = 5'b00111;
            dst_allowed = 5'b11000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Boundary - All Zeros", test_num);
            src = 5'b00000;
            src_allowed = 5'b00000;
            dst = 5'b00000;
            dst_allowed = 5'b00000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Boundary - All Ones", test_num);
            src = 5'b11111;
            src_allowed = 5'b11111;
            dst = 5'b11111;
            dst_allowed = 5'b11111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Partial Bit Match", test_num);
            src = 5'b11110;
            src_allowed = 5'b11111;
            dst = 5'b00001;
            dst_allowed = 5'b00001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_valid_packet;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valid_packet === (expected_valid_packet ^ valid_packet ^ expected_valid_packet)) begin
                $display("PASS");
                $display("  Outputs: valid_packet=%b",
                         valid_packet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_packet=%b",
                         expected_valid_packet);
                $display("  Got:      valid_packet=%b",
                         valid_packet);
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

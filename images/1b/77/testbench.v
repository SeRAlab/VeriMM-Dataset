`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] filter_id;
    reg [15:0] packet;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .filter_id(filter_id),
        .packet(packet),
        .allow(allow)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 0 - Match 16'hAAAA", test_num);
        filter_id = 3'd0;
        packet = 16'hAAAA;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 0 - Mismatch", test_num);
        filter_id = 3'd0;
        packet = 16'h5555;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 1 - Match 16'h5555", test_num);
        filter_id = 3'd1;
        packet = 16'h5555;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 2 - Match Upper Byte 0xFF", test_num);
        filter_id = 3'd2;
        packet = 16'hFF12;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 3 - Match Lower Byte 0x00", test_num);
        filter_id = 3'd3;
        packet = 16'hABCD;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 4 - Match Packet > 0x8000", test_num);
        filter_id = 3'd4;
        packet = 16'h9000;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 5 - Match Packet < 0x1000", test_num);
        filter_id = 3'd5;
        packet = 16'h0FFF;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 6 - Match Odd Packet", test_num);
        filter_id = 3'd6;
        packet = 16'h0001;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filter ID 7 - Match MSB Nibble 0xE", test_num);
        filter_id = 3'd7;
        packet = 16'hEFFF;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switching Filter IDs", test_num);
        packet = 16'hAAAA;
        filter_id = 3'd0;
        #10;
        if (allow == 1'b1) begin
            filter_id = 3'd1;
            #10;
            #1;

            check_outputs(1'b0);
        end else begin
            $display("Initial state for Test 10 failed, skipping check.");
            fail_count = fail_count + 1;
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
        $display("packet_filter Testbench");
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
        input expected_allow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allow === (expected_allow ^ allow ^ expected_allow)) begin
                $display("PASS");
                $display("  Outputs: allow=%b",
                         allow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allow=%b",
                         expected_allow);
                $display("  Got:      allow=%b",
                         allow);
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

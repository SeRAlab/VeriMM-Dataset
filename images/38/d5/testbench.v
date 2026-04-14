`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] filter;
    reg [15:0] packet;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .filter(filter),
        .packet(packet),
        .allow(allow)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Exact match - MSB 10, LSB 01", test_num);
        filter = 4'b1001;
        packet = 16'b1000_1111_0000_0101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Mismatch MSB (Filter 10, Packet 11)", test_num);
        filter = 4'b1001;
        packet = 16'b1100_0000_1111_0001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Mismatch LSB (Filter 01, Packet 11)", test_num);
        filter = 4'b1001;
        packet = 16'b1011_1111_0000_1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Match with all bits high", test_num);
        filter = 4'b1111;
        packet = 16'hFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Match with all bits low", test_num);
        filter = 4'b0000;
        packet = 16'h0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Middle bits variation check (Match)", test_num);
        filter = 4'b0110;
        packet = 16'b0110_1010_0101_1010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Middle bits variation check (Mismatch)", test_num);
        filter = 4'b0110;
        packet = 16'b0010_1010_0101_1010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Boundary match 00..11", test_num);
        filter = 4'b0011;
        packet = 16'b0011_0011_0011_0011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Full mismatch (Both segments wrong)", test_num);
        filter = 4'b1111;
        packet = 16'b0000_0000_0000_0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Alternate match 11..00", test_num);
        filter = 4'b1100;
        packet = 16'b1101_0101_0101_0100;
        #1;

        check_outputs(1'b1);
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

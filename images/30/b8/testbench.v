`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] allowlist_0;
    reg [15:0] allowlist_1;
    reg [15:0] allowlist_2;
    reg [15:0] allowlist_3;
    reg [15:0] packet_header;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .allowlist_0(allowlist_0),
        .allowlist_1(allowlist_1),
        .allowlist_2(allowlist_2),
        .allowlist_3(allowlist_3),
        .packet_header(packet_header),
        .allow(allow)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Match entry 0", test_num);
        allowlist_0 = 16'hAAAA;
        allowlist_1 = 16'hBBBB;
        allowlist_2 = 16'hCCCC;
        allowlist_3 = 16'hDDDD;
        packet_header = 16'hAAAA;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Match entry 1", test_num);
        allowlist_0 = 16'h1234;
        allowlist_1 = 16'h5678;
        allowlist_2 = 16'h90AB;
        allowlist_3 = 16'hCDEF;
        packet_header = 16'h5678;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Match entry 2", test_num);
        allowlist_0 = 16'h0001;
        allowlist_1 = 16'h0002;
        allowlist_2 = 16'h0003;
        allowlist_3 = 16'h0004;
        packet_header = 16'h0003;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Match entry 3", test_num);
        allowlist_0 = 16'hFFFF;
        allowlist_1 = 16'hEEEE;
        allowlist_2 = 16'hDDDD;
        allowlist_3 = 16'hCCCC;
        packet_header = 16'hCCCC;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: No match - random header", test_num);
        allowlist_0 = 16'h1111;
        allowlist_1 = 16'h2222;
        allowlist_2 = 16'h3333;
        allowlist_3 = 16'h4444;
        packet_header = 16'h5555;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: No match - near miss (1 bit off)", test_num);
        allowlist_0 = 16'h0001;
        allowlist_1 = 16'h0002;
        allowlist_2 = 16'h0004;
        allowlist_3 = 16'h0008;
        packet_header = 16'h0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: All entries identical - Match", test_num);
        allowlist_0 = 16'hA5A5;
        allowlist_1 = 16'hA5A5;
        allowlist_2 = 16'hA5A5;
        allowlist_3 = 16'hA5A5;
        packet_header = 16'hA5A5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: All entries identical - No Match", test_num);
        allowlist_0 = 16'h5A5A;
        allowlist_1 = 16'h5A5A;
        allowlist_2 = 16'h5A5A;
        allowlist_3 = 16'h5A5A;
        packet_header = 16'hA5A5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Boundary check - All zeros", test_num);
        allowlist_0 = 16'h0000;
        allowlist_1 = 16'h0001;
        allowlist_2 = 16'h0002;
        allowlist_3 = 16'h0003;
        packet_header = 16'h0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Boundary check - All ones", test_num);
        allowlist_0 = 16'hFFFE;
        allowlist_1 = 16'hFFFF;
        allowlist_2 = 16'h0000;
        allowlist_3 = 16'hABCD;
        packet_header = 16'hFFFF;
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

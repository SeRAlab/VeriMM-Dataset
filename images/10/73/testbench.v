`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dest_ip;
    reg [15:0] rule_dest_0;
    reg [15:0] rule_dest_1;
    reg [15:0] rule_dest_2;
    reg [15:0] rule_dest_3;
    reg [15:0] rule_src_0;
    reg [15:0] rule_src_1;
    reg [15:0] rule_src_2;
    reg [15:0] rule_src_3;
    reg [15:0] src_ip;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .rule_dest_0(rule_dest_0),
        .rule_dest_1(rule_dest_1),
        .rule_dest_2(rule_dest_2),
        .rule_dest_3(rule_dest_3),
        .rule_src_0(rule_src_0),
        .rule_src_1(rule_src_1),
        .rule_src_2(rule_src_2),
        .rule_src_3(rule_src_3),
        .src_ip(src_ip),
        .allow(allow)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Match Rule 0 exactly", test_num);
            rule_src_0 = 16'hAAAA; rule_dest_0 = 16'h5555;
            rule_src_1 = 16'h1111; rule_dest_1 = 16'h2222;
            rule_src_2 = 16'h3333; rule_dest_2 = 16'h4444;
            rule_src_3 = 16'h7777; rule_dest_3 = 16'h8888;
            src_ip = 16'hAAAA;
            dest_ip = 16'h5555;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Match Rule 1 exactly", test_num);
            rule_src_0 = 16'hAAAA; rule_dest_0 = 16'h5555;
            rule_src_1 = 16'h1234; rule_dest_1 = 16'h4321;
            rule_src_2 = 16'h3333; rule_dest_2 = 16'h4444;
            rule_src_3 = 16'h7777; rule_dest_3 = 16'h8888;
            src_ip = 16'h1234;
            dest_ip = 16'h4321;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Match Rule 2 exactly", test_num);
            rule_src_0 = 16'hAAAA; rule_dest_0 = 16'h5555;
            rule_src_1 = 16'h1111; rule_dest_1 = 16'h2222;
            rule_src_2 = 16'hBEEF; rule_dest_2 = 16'hDEAD;
            rule_src_3 = 16'h7777; rule_dest_3 = 16'h8888;
            src_ip = 16'hBEEF;
            dest_ip = 16'hDEAD;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Match Rule 3 exactly", test_num);
            rule_src_0 = 16'hAAAA; rule_dest_0 = 16'h5555;
            rule_src_1 = 16'h1111; rule_dest_1 = 16'h2222;
            rule_src_2 = 16'h3333; rule_dest_2 = 16'h4444;
            rule_src_3 = 16'hFFFF; rule_dest_3 = 16'h0000;
            src_ip = 16'hFFFF;
            dest_ip = 16'h0000;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Mismatch - Source matches but Destination fails", test_num);
            rule_src_0 = 16'hAAAA; rule_dest_0 = 16'h5555;
            rule_src_1 = 16'h1111; rule_dest_1 = 16'h2222;
            rule_src_2 = 16'h3333; rule_dest_2 = 16'h4444;
            rule_src_3 = 16'h7777; rule_dest_3 = 16'h8888;
            src_ip = 16'hAAAA;
            dest_ip = 16'hFFFF;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Mismatch - Destination matches but Source fails", test_num);
            rule_src_0 = 16'hAAAA; rule_dest_0 = 16'h5555;
            rule_src_1 = 16'h1111; rule_dest_1 = 16'h2222;
            rule_src_2 = 16'h3333; rule_dest_2 = 16'h4444;
            rule_src_3 = 16'h7777; rule_dest_3 = 16'h8888;
            src_ip = 16'h0000;
            dest_ip = 16'h5555;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Complete Mismatch", test_num);
            rule_src_0 = 16'h0001; rule_dest_0 = 16'h0001;
            rule_src_1 = 16'h0002; rule_dest_1 = 16'h0002;
            rule_src_2 = 16'h0003; rule_dest_2 = 16'h0003;
            rule_src_3 = 16'h0004; rule_dest_3 = 16'h0004;
            src_ip = 16'hFFFF;
            dest_ip = 16'hFFFF;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Multiple rules match", test_num);
            rule_src_0 = 16'h1234; rule_dest_0 = 16'h5678;
            rule_src_1 = 16'h1234; rule_dest_1 = 16'h5678;
            rule_src_2 = 16'h1234; rule_dest_2 = 16'h5678;
            rule_src_3 = 16'h1234; rule_dest_3 = 16'h5678;
            src_ip = 16'h1234;
            dest_ip = 16'h5678;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Edge case - All zeros rule", test_num);
            rule_src_0 = 16'h0000; rule_dest_0 = 16'h0000;
            rule_src_1 = 16'hFFFF; rule_dest_1 = 16'hFFFF;
            rule_src_2 = 16'hFFFF; rule_dest_2 = 16'hFFFF;
            rule_src_3 = 16'hFFFF; rule_dest_3 = 16'hFFFF;
            src_ip = 16'h0000;
            dest_ip = 16'h0000;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Edge case - All 1s packet with specific rule set", test_num);
            rule_src_0 = 16'hAAAA; rule_dest_0 = 16'h5555;
            rule_src_1 = 16'h1111; rule_dest_1 = 16'h2222;
            rule_src_2 = 16'h3333; rule_dest_2 = 16'h4444;
            rule_src_3 = 16'hFFFF; rule_dest_3 = 16'hFFFF;
            src_ip = 16'hFFFF;
            dest_ip = 16'hFFFF;
            #1;

            check_outputs(1);
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

`timescale 1ns/1ps

module tcp_segment_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] segment_length;
    reg [4:0] tcp_flags;
    wire [1:0] segment_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segment_classifier dut (
        .segment_length(segment_length),
        .tcp_flags(tcp_flags),
        .segment_type(segment_type)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid FIN Segment (Length 500, Flag bit 0)", test_num);
            segment_length = 16'd500;
            tcp_flags = 5'b00001;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid SYN Segment (Length 1000, Flag bit 1)", test_num);
            segment_length = 16'd1000;
            tcp_flags = 5'b00010;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid RST Segment (Length 1499, Flag bit 2)", test_num);
            segment_length = 16'd1499;
            tcp_flags = 5'b00100;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Length 1500 (FIN)", test_num);
            segment_length = 16'd1500;
            tcp_flags = 5'b00001;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid Length 1501 (FIN)", test_num);
            segment_length = 16'd1501;
            tcp_flags = 5'b00001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid Length 2000 (SYN)", test_num);
            segment_length = 16'd2000;
            tcp_flags = 5'b00010;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No relevant flags set (ACK/PSH only)", test_num);
            segment_length = 16'd100;
            tcp_flags = 5'b11000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Length 0, No flags", test_num);
            segment_length = 16'd0;
            tcp_flags = 5'b00000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Length 65535 with RST", test_num);
            segment_length = 16'hFFFF;
            tcp_flags = 5'b00100;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SYN + ACK flags (Length 50)", test_num);
            segment_length = 16'd50;
            tcp_flags = 5'b10010;
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segment_classifier Testbench");
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
        input [1:0] expected_segment_type;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segment_type === (expected_segment_type ^ segment_type ^ expected_segment_type)) begin
                $display("PASS");
                $display("  Outputs: segment_type=%h",
                         segment_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment_type=%h",
                         expected_segment_type);
                $display("  Got:      segment_type=%h",
                         segment_type);
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

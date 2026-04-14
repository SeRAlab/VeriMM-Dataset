`timescale 1ns/1ps

module tcp_segment_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] tcp_flags;
    wire [1:0] segment_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segment_classifier dut (
        .tcp_flags(tcp_flags),
        .segment_type(segment_type)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing SYN (assuming input 3'b001)", test_num);
        tcp_flags = 3'b001;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing ACK (assuming input 3'b010)", test_num);
        tcp_flags = 3'b010;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing DATA (assuming input 3'b100)", test_num);
        tcp_flags = 3'b100;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing No Flags (input 3'b000) -> expect 2'b11", test_num);
        tcp_flags = 3'b000;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing Combined Flags (input 3'b011) -> expect 2'b11", test_num);
        tcp_flags = 3'b011;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing Combined Flags (input 3'b101) -> expect 2'b11", test_num);
        tcp_flags = 3'b101;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing Combined Flags (input 3'b110) -> expect 2'b11", test_num);
        tcp_flags = 3'b110;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Testing All Flags (input 3'b111) -> expect 2'b11", test_num);
        tcp_flags = 3'b111;
        #1;

        check_outputs(2'b11);
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

`timescale 1ns/1ps

module tcp_segment_type_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] segment;
    wire [15:0] segment_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segment_type dut (
        .segment(segment),
        .segment_type(segment_type)
    );
    task testcase001;

        begin
            $display("Testcase 001: Data Segment (Input 3'b000)");
            segment = 32'h0000_0000;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: SYN Segment (Input 3'b001)");
            segment = 32'h0000_0001;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: ACK Segment (Input 3'b010)");
            segment = 32'h0000_0002;
            #1;

            check_outputs(16'd2);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: FIN Segment (Input 3'b011)");
            segment = 32'h0000_0003;
            #1;

            check_outputs(16'd3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: RST Segment (Input 3'b100)");
            segment = 32'h0000_0004;
            #1;

            check_outputs(16'd4);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Data Segment with non-zero upper bits");
            segment = 32'hAAAA_BBBB;
            segment[2:0] = 3'b000;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: SYN Segment with all high bits set");
            segment = 32'hFFFF_FFFF;
            segment[31:3] = 29'h1FFFFFFF;
            segment[2:0] = 3'b001;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: ACK Segment with random upper bits");
            segment = 32'h1234_5678;
            segment[2:0] = 3'b010;
            #1;

            check_outputs(16'd2);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: FIN Segment with random upper bits");
            segment = 32'hDEAD_BEEF;
            segment[2:0] = 3'b011;
            #1;

            check_outputs(16'd3);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: RST Segment with alternating upper bits");
            segment = 32'h5555_5555;
            segment[2:0] = 3'b100;
            #1;

            check_outputs(16'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segment_type Testbench");
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
        input [15:0] expected_segment_type;
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

`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg [1:0] seg_type;
    wire [1:0] num_packets;
    wire [15:0] seg_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .data_in(data_in),
        .seg_type(seg_type),
        .num_packets(num_packets),
        .seg_data(seg_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data_in = 16'hAAAA;
            seg_type = 2'b00;
            $display("Test %0d: Type 00 - No segmentation (1 packet expected)", test_num);
            #1;

            check_outputs(2'b00, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data_in = 16'h5555;
            seg_type = 2'b01;
            $display("Test %0d: Type 01 - 2 packets (8 bits each expected)", test_num);
            #1;

            check_outputs(2'b01, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data_in = 16'hF0F0;
            seg_type = 2'b10;
            $display("Test %0d: Type 10 - 4 packets (4 bits each expected)", test_num);
            #1;

            check_outputs(2'b10, 16'hF0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data_in = 16'h1234;
            seg_type = 2'b11;
            $display("Test %0d: Type 11 - 8 packets (2 bits each expected)", test_num);
            #1;

            check_outputs(2'b11, 16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data_in = 16'hFFFF;
            seg_type = 2'b01;
            $display("Test %0d: Boundary check - All ones, Type 01", test_num);
            #1;

            check_outputs(2'b01, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data_in = 16'h0000;
            seg_type = 2'b11;
            $display("Test %0d: Boundary check - All zeros, Type 11", test_num);
            #1;

            check_outputs(2'b11, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data_in = 16'hC0DE;
            seg_type = 2'b10;
            $display("Test %0d: Pattern check - 16'hC0DE, Type 10", test_num);
            #1;

            check_outputs(2'b10, 16'hC0DE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmentation Testbench");
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
        input [1:0] expected_num_packets;
        input [15:0] expected_seg_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_num_packets === (expected_num_packets ^ num_packets ^ expected_num_packets) &&
                expected_seg_data === (expected_seg_data ^ seg_data ^ expected_seg_data)) begin
                $display("PASS");
                $display("  Outputs: num_packets=%h, seg_data=%h",
                         num_packets, seg_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_packets=%h, seg_data=%h",
                         expected_num_packets, expected_seg_data);
                $display("  Got:      num_packets=%h, seg_data=%h",
                         num_packets, seg_data);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [255:0] address1;
    reg [255:0] address2;
    reg clock;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg write_en1;
    reg write_en2;
    wire [7:0] data_out1;
    wire [7:0] data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address1(address1),
        .address2(address2),
        .clock(clock),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .write_en1(write_en1),
        .write_en2(write_en2),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address1 = 0;
            address2 = 0;
            data_in1 = 0;
            data_in2 = 0;
            write_en1 = 0;
            write_en2 = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Port 1 Basic Write/Read", test_num);
            reset_dut();

            address1 = 8'h0A;
            data_in1 = 8'hAA;
            write_en1 = 1;
            @(posedge clock);

            #1;
            write_en1 = 0;

            #1;


            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Port 2 Basic Write/Read", test_num);
            reset_dut();

            address2 = 8'h0B;
            data_in2 = 8'hBB;
            write_en2 = 1;
            @(posedge clock);

            #1;
            write_en2 = 0;
            #1;

            check_outputs(8'h00, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simultaneous Dual Port Write", test_num);
            reset_dut();

            address1 = 8'h10; data_in1 = 8'h11; write_en1 = 1;
            address2 = 8'h20; data_in2 = 8'h22; write_en2 = 1;
            @(posedge clock);

            #1;
            write_en1 = 0; write_en2 = 0;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Cross Port Access (Write P1, Read P2)", test_num);
            reset_dut();


            address1 = 8'h55; data_in1 = 8'hC3; write_en1 = 1;
            @(posedge clock);

            #1;
            write_en1 = 0;

            address2 = 8'h55;
            @(posedge clock);

            #1;
            #1;

            check_outputs(8'h00, 8'hC3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write Enable Inhibition", test_num);
            reset_dut();


            address1 = 8'h66; data_in1 = 8'hFF; write_en1 = 1;
            @(posedge clock);

            #1;

            data_in1 = 8'h00; write_en1 = 0;
            @(posedge clock);

            #1;

            #1;


            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Concurrent Dual Port Read", test_num);
            reset_dut();


            address1 = 8'h70; data_in1 = 8'hDE; write_en1 = 1;
            address2 = 8'h80; data_in2 = 8'hAD; write_en2 = 1;
            @(posedge clock);

            #1;
            write_en1 = 0; write_en2 = 0;

            address1 = 8'h70;
            address2 = 8'h80;
            @(posedge clock);

            #1;
            #1;

            check_outputs(8'hDE, 8'hAD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,address1, address2, clock, data_in1, data_in2, write_en1, write_en2, data_out1, data_out2);
    end

endmodule

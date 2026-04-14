`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_ch1;
    reg req_ch2;
    reg rst;
    wire ack_ch1;
    wire ack_ch2;
    wire status_ch1;
    wire status_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req_ch1(req_ch1),
        .req_ch2(req_ch2),
        .rst(rst),
        .ack_ch1(ack_ch1),
        .ack_ch2(ack_ch2),
        .status_ch1(status_ch1),
        .status_ch2(status_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req_ch1 = 0;
            req_ch2 = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Single Channel 1 Request", test_num);
            reset_dut();

            req_ch1 = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single Channel 2 Request", test_num);
            reset_dut();

            req_ch2 = 1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Simultaneous Request (Fresh Start)", test_num);
            reset_dut();

            req_ch1 = 1;
            req_ch2 = 1;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Round-Robin Alternation", test_num);
            reset_dut();


            req_ch1 = 1;
            @(posedge clk);



            req_ch2 = 1;
            @(posedge clk);
            req_ch1 = 0;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Status Bit Toggling", test_num);
            reset_dut();


            req_ch1 = 1;
            @(posedge clk);
            #1;



            req_ch1 = 0;
            @(posedge clk);


            req_ch1 = 1;
            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: RR Contention (CH2 follows CH1)", test_num);
            reset_dut();


            req_ch1 = 1;
            @(posedge clk);
            req_ch1 = 0;
            @(posedge clk);


            req_ch1 = 1;
            req_ch2 = 1;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_ack_ch1;
        input expected_ack_ch2;
        input expected_status_ch1;
        input expected_status_ch2;
        begin
            if (expected_ack_ch1 === (expected_ack_ch1 ^ ack_ch1 ^ expected_ack_ch1) &&
                expected_ack_ch2 === (expected_ack_ch2 ^ ack_ch2 ^ expected_ack_ch2) &&
                expected_status_ch1 === (expected_status_ch1 ^ status_ch1 ^ expected_status_ch1) &&
                expected_status_ch2 === (expected_status_ch2 ^ status_ch2 ^ expected_status_ch2)) begin
                $display("PASS");
                $display("  Outputs: ack_ch1=%b, ack_ch2=%b, status_ch1=%b, status_ch2=%b",
                         ack_ch1, ack_ch2, status_ch1, status_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_ch1=%b, ack_ch2=%b, status_ch1=%b, status_ch2=%b",
                         expected_ack_ch1, expected_ack_ch2, expected_status_ch1, expected_status_ch2);
                $display("  Got:      ack_ch1=%b, ack_ch2=%b, status_ch1=%b, status_ch2=%b",
                         ack_ch1, ack_ch2, status_ch1, status_ch2);
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
        $dumpvars(0,clk, req_ch1, req_ch2, rst, ack_ch1, ack_ch2, status_ch1, status_ch2);
    end

endmodule

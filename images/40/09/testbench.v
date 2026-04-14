`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr1;
    reg [7:0] dest_addr2;
    reg [7:0] length1;
    reg [7:0] length2;
    reg reset;
    reg [7:0] src_addr1;
    reg [7:0] src_addr2;
    reg start_channel1;
    reg start_channel2;
    wire busy_channel1;
    wire busy_channel2;
    wire done_channel1;
    wire done_channel2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr1(dest_addr1),
        .dest_addr2(dest_addr2),
        .length1(length1),
        .length2(length2),
        .reset(reset),
        .src_addr1(src_addr1),
        .src_addr2(src_addr2),
        .start_channel1(start_channel1),
        .start_channel2(start_channel2),
        .busy_channel1(busy_channel1),
        .busy_channel2(busy_channel2),
        .done_channel1(done_channel1),
        .done_channel2(done_channel2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            start_channel1 = 0;
            start_channel2 = 0;
            src_addr1 = 0;
            dest_addr1 = 0;
            length1 = 0;
            src_addr2 = 0;
            dest_addr2 = 0;
            length2 = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Channel 1 Basic Transfer", test_num);
            reset_dut();


            src_addr1 = 8'h10;
            dest_addr1 = 8'h50;
            length1 = 8'h05;

            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;


            wait(done_channel1 == 1);
            @(posedge clk);


            #1;



            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Channel 2 Basic Transfer", test_num);
            reset_dut();


            src_addr2 = 8'h20;
            dest_addr2 = 8'h60;
            length2 = 8'h03;

            @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;


            wait(done_channel2 == 1);
            @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Concurrent Channel 1 & 2 Transfer", test_num);
            reset_dut();

            src_addr1 = 8'hA0; dest_addr1 = 8'hB0; length1 = 8'h04;
            src_addr2 = 8'hC0; dest_addr2 = 8'hD0; length2 = 8'h04;

            @(posedge clk);
            start_channel1 = 1;
            start_channel2 = 1;
            @(posedge clk);
            start_channel1 = 0;
            start_channel2 = 0;


            wait(done_channel1 && done_channel2);
            @(posedge clk);


            #1;



            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Length Transfer", test_num);
            reset_dut();

            src_addr1 = 8'h05;
            dest_addr1 = 8'h06;
            length1 = 8'h00;

            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;


            repeat(5) @(posedge clk);



            #1;




            check_outputs(0, 0, done_channel1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset During Active Transfer", test_num);
            reset_dut();

            src_addr1 = 8'h11;
            dest_addr1 = 8'h22;
            length1 = 8'hFF;

            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;


            wait(busy_channel1 == 1);
            repeat(5) @(posedge clk);


            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 0);
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
        input expected_busy_channel1;
        input expected_busy_channel2;
        input expected_done_channel1;
        input expected_done_channel2;
        begin
            if (expected_busy_channel1 === (expected_busy_channel1 ^ busy_channel1 ^ expected_busy_channel1) &&
                expected_busy_channel2 === (expected_busy_channel2 ^ busy_channel2 ^ expected_busy_channel2) &&
                expected_done_channel1 === (expected_done_channel1 ^ done_channel1 ^ expected_done_channel1) &&
                expected_done_channel2 === (expected_done_channel2 ^ done_channel2 ^ expected_done_channel2)) begin
                $display("PASS");
                $display("  Outputs: busy_channel1=%b, busy_channel2=%b, done_channel1=%b, done_channel2=%b",
                         busy_channel1, busy_channel2, done_channel1, done_channel2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy_channel1=%b, busy_channel2=%b, done_channel1=%b, done_channel2=%b",
                         expected_busy_channel1, expected_busy_channel2, expected_done_channel1, expected_done_channel2);
                $display("  Got:      busy_channel1=%b, busy_channel2=%b, done_channel1=%b, done_channel2=%b",
                         busy_channel1, busy_channel2, done_channel1, done_channel2);
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
        $dumpvars(0,clk, dest_addr1, dest_addr2, length1, length2, reset, src_addr1, src_addr2, start_channel1, start_channel2, busy_channel1, busy_channel2, done_channel1, done_channel2);
    end

endmodule

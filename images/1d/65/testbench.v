`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg reset;
    reg start;
    wire frame_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .start(start),
        .frame_valid(frame_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Basic Transmission", test_num);
            reset_dut();

            @(posedge clk);
            #1 start = 1;
            data = 8'hAA;
            @(posedge clk);
            #1 start = 0;



            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Idle State Check", test_num);
            reset_dut();

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Reset during Transmission", test_num);
            reset_dut();

            @(posedge clk);
            #1 start = 1;
            data = 8'h55;
            @(posedge clk);
            #1 start = 0;

            repeat(2) @(posedge clk);

            #1 reset = 1;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Consecutive Transmissions", test_num);
            reset_dut();


            @(posedge clk);
            #1 start = 1;
            data = 8'h11;
            @(posedge clk);
            #1 start = 0;
            repeat(10) @(posedge clk);


            @(posedge clk);
            #1 start = 1;
            data = 8'h22;
            @(posedge clk);
            #1 start = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Data Change mid-transmission", test_num);
            reset_dut();

            @(posedge clk);
            #1 start = 1;
            data = 8'hF0;
            @(posedge clk);
            #1 start = 0;
            data = 8'h0F;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input expected_frame_valid;
        begin
            if (expected_frame_valid === (expected_frame_valid ^ frame_valid ^ expected_frame_valid)) begin
                $display("PASS");
                $display("  Outputs: frame_valid=%b",
                         frame_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_valid=%b",
                         expected_frame_valid);
                $display("  Got:      frame_valid=%b",
                         frame_valid);
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
        $dumpvars(0,clk, data, reset, start, frame_valid);
    end

endmodule

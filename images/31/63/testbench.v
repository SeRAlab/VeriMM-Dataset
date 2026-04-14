`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] channel0_address;
    reg channel0_enable;
    reg [7:0] channel1_address;
    reg channel1_enable;
    reg clk;
    reg reset;
    wire channel0_done;
    wire channel1_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel0_address(channel0_address),
        .channel0_enable(channel0_enable),
        .channel1_address(channel1_address),
        .channel1_enable(channel1_enable),
        .clk(clk),
        .reset(reset),
        .channel0_done(channel0_done),
        .channel1_done(channel1_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel0_enable = 0;
            channel1_enable = 0;
            channel0_address = 8'h00;
            channel1_address = 8'h00;
            repeat(2) @(posedge clk);
            reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 0 Single Transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel0_address = 8'hAA;
            channel0_enable = 1;


            repeat(5) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Single Transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel1_address = 8'h55;
            channel1_enable = 1;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dual Channel Simultaneous Transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel0_address = 8'h11;
            channel1_address = 8'h22;
            channel0_enable = 1;
            channel1_enable = 1;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Independent Disable (Enables Low)", test_num);
            reset_dut();

            @(posedge clk);
            channel0_address = 8'hFF;
            channel1_address = 8'hEE;
            channel0_enable = 0;
            channel1_enable = 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 0 Max Address", test_num);
            reset_dut();

            @(posedge clk);
            channel0_address = 8'hFF;
            channel0_enable = 1;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Transfers", test_num);
            reset_dut();


            @(posedge clk);
            channel0_address = 8'h10;
            channel0_enable = 1;
            repeat(5) @(posedge clk);


            channel0_enable = 0;
            channel1_address = 8'h20;
            channel1_enable = 1;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1);
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
        input expected_channel0_done;
        input expected_channel1_done;
        begin
            if (expected_channel0_done === (expected_channel0_done ^ channel0_done ^ expected_channel0_done) &&
                expected_channel1_done === (expected_channel1_done ^ channel1_done ^ expected_channel1_done)) begin
                $display("PASS");
                $display("  Outputs: channel0_done=%b, channel1_done=%b",
                         channel0_done, channel1_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel0_done=%b, channel1_done=%b",
                         expected_channel0_done, expected_channel1_done);
                $display("  Got:      channel0_done=%b, channel1_done=%b",
                         channel0_done, channel1_done);
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
        $dumpvars(0,channel0_address, channel0_enable, channel1_address, channel1_enable, clk, reset, channel0_done, channel1_done);
    end

endmodule

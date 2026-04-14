`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] channel1_data;
    reg channel1_enable;
    reg [7:0] channel2_data;
    reg channel2_enable;
    reg clk;
    reg reset;
    wire channel1_state;
    wire channel2_state;
    wire [7:0] mem_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel1_data(channel1_data),
        .channel1_enable(channel1_enable),
        .channel2_data(channel2_data),
        .channel2_enable(channel2_enable),
        .clk(clk),
        .reset(reset),
        .channel1_state(channel1_state),
        .channel2_state(channel2_state),
        .mem_data(mem_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel1_enable = 0;
            channel2_enable = 0;
            channel1_data = 8'h00;
            channel2_data = 8'h00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Channel 1 Single Byte Transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel1_enable = 1;
            channel1_data = 8'hAA;


            repeat(3) @(posedge clk);

            channel1_enable = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Channel 2 Single Byte Transfer", test_num);
            reset_dut();

            @(posedge clk);
            channel2_enable = 1;
            channel2_data = 8'h55;


            repeat(3) @(posedge clk);

            channel2_enable = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Simultaneous Channel Enable (Priority Check)", test_num);
            reset_dut();

            @(posedge clk);
            channel1_enable = 1;
            channel1_data = 8'h11;
            channel2_enable = 1;
            channel2_data = 8'h22;


            repeat(3) @(posedge clk);



            repeat(3) @(posedge clk);

            channel1_enable = 0;
            channel2_enable = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Idle Data Stability", test_num);
            reset_dut();


            @(posedge clk);
            channel1_enable = 1;
            channel1_data = 8'hBC;
            repeat(3) @(posedge clk);
            channel1_enable = 0;
            @(posedge clk);


            channel1_data = 8'hFF;
            channel2_data = 8'hEE;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'hBC);
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
        input expected_channel1_state;
        input expected_channel2_state;
        input [7:0] expected_mem_data;
        begin
            if (expected_channel1_state === (expected_channel1_state ^ channel1_state ^ expected_channel1_state) &&
                expected_channel2_state === (expected_channel2_state ^ channel2_state ^ expected_channel2_state) &&
                expected_mem_data === (expected_mem_data ^ mem_data ^ expected_mem_data)) begin
                $display("PASS");
                $display("  Outputs: channel1_state=%b, channel2_state=%b, mem_data=%h",
                         channel1_state, channel2_state, mem_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel1_state=%b, channel2_state=%b, mem_data=%h",
                         expected_channel1_state, expected_channel2_state, expected_mem_data);
                $display("  Got:      channel1_state=%b, channel2_state=%b, mem_data=%h",
                         channel1_state, channel2_state, mem_data);
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
        $dumpvars(0,channel1_data, channel1_enable, channel2_data, channel2_enable, clk, reset, channel1_state, channel2_state, mem_data);
    end

endmodule

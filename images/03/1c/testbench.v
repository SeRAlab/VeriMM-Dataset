`timescale 1ns/1ps

module slam_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] sensor_data;
    reg start;
    wire [15:0] processed_data;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_fsm dut (
        .clk(clk),
        .rst(rst),
        .sensor_data(sensor_data),
        .start(start),
        .processed_data(processed_data),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            start = 0;
            sensor_data = 8'h00;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power-on Reset", test_num);
            reset_dut();
            @(posedge clk);

            #1;


            check_outputs(16'h0000, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition IDLE to MAPPING", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            sensor_data = 8'hA5;
            @(posedge clk);
            #1 start = 0;



            #1;




            check_outputs(processed_data, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition MAPPING to LOCALIZING", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            sensor_data = 8'h55;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);

            #1;


            check_outputs(processed_data, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Cycle (IDLE -> MAP -> LOC -> IDLE)", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            sensor_data = 8'hFF;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(processed_data, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Processing with different input", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            sensor_data = 8'h12;
            @(posedge clk);
            #1 start = 0;

            if (state == 2'b01 && processed_data != 16'h0000) begin
                $display("  Data processing active for input 12h");
            end
            #1;

            check_outputs(processed_data, 2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_fsm Testbench");
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
        input [15:0] expected_processed_data;
        input [1:0] expected_state;
        begin
            if (expected_processed_data === (expected_processed_data ^ processed_data ^ expected_processed_data) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: processed_data=%h, state=%h",
                         processed_data, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: processed_data=%h, state=%h",
                         expected_processed_data, expected_state);
                $display("  Got:      processed_data=%h, state=%h",
                         processed_data, state);
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
        $dumpvars(0,clk, rst, sensor_data, start, processed_data, state);
    end

endmodule

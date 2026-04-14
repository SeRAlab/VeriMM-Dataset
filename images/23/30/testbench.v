`timescale 1ns/1ps

module current_sensor_logger_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_data;
    reg reset;
    wire [3:0] counter;
    wire [7:0] logged_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor_logger dut (
        .clk(clk),
        .current_data(current_data),
        .reset(reset),
        .counter(counter),
        .logged_data(logged_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        current_data = 8'h00;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Single Data Capture", test_num);
        reset_dut();

        current_data = 8'hA5;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'h1, 8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Multiple Consecutive Captures", test_num);
        reset_dut();

        current_data = 8'h10; @(posedge clk);
        current_data = 8'h20; @(posedge clk);
        current_data = 8'h30; @(posedge clk);
        current_data = 8'h40; @(posedge clk);
        current_data = 8'h55; @(posedge clk);
        #1;


        #1;



        check_outputs(4'h5, 8'h55);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("\nTest %0d: Counter Roll-over (4-bit overflow)", test_num);
        reset_dut();


        for(i = 0; i < 16; i = i + 1) begin
            current_data = i[7:0] + 8'h01;
            @(posedge clk);
        end
        #1;



        #1;




        check_outputs(4'h0, 8'h10);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("\nTest %0d: Capture After Roll-over", test_num);
        reset_dut();


        for(i = 1; i <= 17; i = i + 1) begin
            current_data = i[7:0];
            @(posedge clk);
        end
        #1;


        #1;



        check_outputs(4'h1, 8'h11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Random Data Sequence Integrity", test_num);
        reset_dut();

        current_data = 8'hFF; @(posedge clk);
        current_data = 8'h00; @(posedge clk);
        current_data = 8'hAA; @(posedge clk);
        current_data = 8'h55; @(posedge clk);
        current_data = 8'hBE; @(posedge clk);
        current_data = 8'hEF; @(posedge clk);
        #1;


        #1;



        check_outputs(4'h6, 8'hEF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_sensor_logger Testbench");
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
        input [3:0] expected_counter;
        input [7:0] expected_logged_data;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_logged_data === (expected_logged_data ^ logged_data ^ expected_logged_data)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, logged_data=%h",
                         counter, logged_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, logged_data=%h",
                         expected_counter, expected_logged_data);
                $display("  Got:      counter=%h, logged_data=%h",
                         counter, logged_data);
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
        $dumpvars(0,clk, current_data, reset, counter, logged_data);
    end

endmodule

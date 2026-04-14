`timescale 1ns/1ps

module Timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] load_value;
    reg reset;
    wire [7:0] current_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Timer dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .current_value(current_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            load_value = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Basic Reset and Increment", test_num);
            reset_dut();

            repeat(15) @(posedge clk);
            #1 #1;
 check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Load Value and Increment", test_num);
            reset_dut();
            load = 1;
            load_value = 8'hA0;
            @(posedge clk);
            #1 load = 0;

            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'd170);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Roll-over from Max Value (255 to 0)", test_num);
            reset_dut();
            load = 1;
            load_value = 8'hFE;
            @(posedge clk);
            #1 load = 0;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset Priority Over Load", test_num);
            reset_dut();
            reset = 1;
            load = 1;
            load_value = 8'hFF;
            @(posedge clk);
            #1 reset = 0;
            load = 0;

            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multi-cycle Wrap-around", test_num);
            reset_dut();
            load = 1;
            load_value = 8'd250;
            @(posedge clk);
            #1 load = 0;

            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Load Zero Value", test_num);
            reset_dut();
            load = 1;
            load_value = 8'h55;
            @(posedge clk);
            #1 load_value = 8'h00;
            @(posedge clk);
            #1 load = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Timer Testbench");
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
        input [7:0] expected_current_value;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h",
                         current_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h",
                         expected_current_value);
                $display("  Got:      current_value=%h",
                         current_value);
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
        $dumpvars(0,clk, load, load_value, reset, current_value);
    end

endmodule

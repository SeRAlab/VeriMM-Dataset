`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control_input;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .control_input(control_input),
        .measurement(measurement),
        .reset(reset),
        .estimated_position(estimated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_input = 0;
            measurement = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Zero State", test_num);
            reset_dut();
            measurement = 16'h0000;
            control_input = 16'h0000;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Static Convergence", test_num);
            reset_dut();
            measurement = 16'h03E8;
            control_input = 16'h0000;


            repeat(20) @(posedge clk);



            #1;




            check_outputs(16'h03E8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Control Input (Velocity) Prediction", test_num);
            reset_dut();
            measurement = 16'h0000;
            control_input = 16'h000A;



            repeat(10) begin
                @(posedge clk);


                measurement = measurement + 16'h000A;
            end


            #1;



            check_outputs(16'h0064);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Noise Filtering", test_num);
            reset_dut();
            control_input = 0;


            @(posedge clk) measurement = 16'h00F0;
            @(posedge clk) measurement = 16'h0110;
            @(posedge clk) measurement = 16'h00F5;
            @(posedge clk) measurement = 16'h010A;
            @(posedge clk) measurement = 16'h0100;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'h0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Large Step Response", test_num);
            reset_dut();
            control_input = 0;
            measurement = 16'hFFFF;

            repeat(50) @(posedge clk);

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        input [15:0] expected_estimated_position;
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h",
                         estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h",
                         expected_estimated_position);
                $display("  Got:      estimated_position=%h",
                         estimated_position);
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
        $dumpvars(0,clk, control_input, measurement, reset, estimated_position);
    end

endmodule

`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] measurement;
    reg reset;
    wire [7:0] estimated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .estimated_state(estimated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single Measurement Step (0 to 128)", test_num);
            reset_dut();
            measurement = 8'd128;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Convergence Verification", test_num);
            reset_dut();
            measurement = 8'd200;
            repeat (5) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(8'hC2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Maximum Input (255)", test_num);
            reset_dut();
            measurement = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Tracking High to Low", test_num);
            reset_dut();

            measurement = 8'd200;
            @(posedge clk);
            #1;

            measurement = 8'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h32);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [7:0] expected_estimated_state;
        begin
            if (expected_estimated_state === (expected_estimated_state ^ estimated_state ^ expected_estimated_state)) begin
                $display("PASS");
                $display("  Outputs: estimated_state=%h",
                         estimated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_state=%h",
                         expected_estimated_state);
                $display("  Got:      estimated_state=%h",
                         estimated_state);
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
        $dumpvars(0,clk, measurement, reset, estimated_state);
    end

endmodule

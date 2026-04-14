`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg din_valid;
    reg reset;
    wire [7:0] dout;
    wire dout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .din(din),
        .din_valid(din_valid),
        .reset(reset),
        .dout(dout),
        .dout_valid(dout_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 0;
            din_valid = 0;
            repeat (5) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nStarting Testcase %0d: Single Data Transfer", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            din = 8'hA5;
            din_valid = 1;
            @(posedge clk);
            #1;
            din_valid = 0;


            while (!dout_valid) @(posedge clk);

            #1;


            check_outputs(8'hA5, 1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_data [0:3];
        begin
            test_num = test_num + 1;
            $display("\nStarting Testcase %0d: Sustained Data Stream", test_num);
            reset_dut();

            test_data[0] = 8'h11; test_data[1] = 8'h22;
            test_data[2] = 8'h33; test_data[3] = 8'h44;


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                #1;
                din = test_data[i];
                din_valid = 1;
            end
            @(posedge clk);
            #1;
            din_valid = 0;



            repeat (4) begin
                while (!dout_valid) @(posedge clk);
                @(posedge clk);
            end


            #1;



            check_outputs(8'h44, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nStarting Testcase %0d: Idle State Check", test_num);
            reset_dut();

            repeat (10) @(posedge clk);


            #1;



            check_outputs(dout, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nStarting Testcase %0d: Post-Reset Recovery", test_num);
            reset_dut();


            din = 8'hFF; din_valid = 1;
            repeat (2) @(posedge clk);

            reset_dut();


            @(posedge clk);
            #1;
            din = 8'h7E; din_valid = 1;
            @(posedge clk);
            #1;
            din_valid = 0;

            while (!dout_valid) @(posedge clk);
            #1;

            check_outputs(8'h7E, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_dout;
        input expected_dout_valid;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_dout_valid === (expected_dout_valid ^ dout_valid ^ expected_dout_valid)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, dout_valid=%b",
                         dout, dout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, dout_valid=%b",
                         expected_dout, expected_dout_valid);
                $display("  Got:      dout=%h, dout_valid=%b",
                         dout, dout_valid);
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
        $dumpvars(0,clk, din, din_valid, reset, dout, dout_valid);
    end

endmodule

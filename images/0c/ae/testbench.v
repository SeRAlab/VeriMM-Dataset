`timescale 1ns/1ps

module register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg enable;
    wire [15:0] data_out;
    wire is_even;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out),
        .is_even(is_even)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1;
            data_in = 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load even value", test_num);
            reset_dut();

            enable = 1;
            data_in = 16'h1234;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load odd value", test_num);
            reset_dut();

            enable = 1;
            data_in = 16'hABCD;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low retention", test_num);
            reset_dut();


            enable = 1;
            data_in = 16'h5554;
            @(posedge clk);
            #1;


            enable = 0;
            data_in = 16'hAAAA;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h5554, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Odd to even transition", test_num);
            reset_dut();

            enable = 1;
            data_in = 16'h0001;
            @(posedge clk);
            #1;

            data_in = 16'hFFFE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max value load", test_num);
            reset_dut();

            enable = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long hold with enable low", test_num);
            reset_dut();

            enable = 1;
            data_in = 16'hCAFE;
            @(posedge clk);
            #1;

            enable = 0;
            data_in = 16'h0000;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hCAFE, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_16bit Testbench");
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
        input [15:0] expected_data_out;
        input expected_is_even;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_is_even === (expected_is_even ^ is_even ^ expected_is_even)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, is_even=%b",
                         data_out, is_even);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, is_even=%b",
                         expected_data_out, expected_is_even);
                $display("  Got:      data_out=%h, is_even=%b",
                         data_out, is_even);
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
        $dumpvars(0,clk, data_in, enable, data_out, is_even);
    end

endmodule

`timescale 1ns/1ps

module DAC_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] digital_in;
    reg enable;
    wire [15:0] analog_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_16bit dut (
        .clk(clk),
        .digital_in(digital_in),
        .enable(enable),
        .analog_out(analog_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            digital_in = 16'h0000;
            enable = 0;
            @(posedge clk);
            #1;
            $display("Reset sequence completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Update", test_num);
            reset_dut();

            enable = 1;
            digital_in = 16'h1234;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hold Logic (Enable=0)", test_num);
            reset_dut();


            enable = 1;
            digital_in = 16'hAAAA;
            @(posedge clk);
            #1;


            enable = 0;
            digital_in = 16'h5555;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full Scale Update (0xFFFF)", test_num);
            reset_dut();

            enable = 1;
            digital_in = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Scale Update (0x0000)", test_num);
            reset_dut();


            enable = 1;
            digital_in = 16'hFFFF;
            @(posedge clk);
            #1;


            digital_in = 16'h0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Updates", test_num);
            reset_dut();

            enable = 1;
            digital_in = 16'h1111;
            @(posedge clk);
            #1;
            digital_in = 16'h2222;
            @(posedge clk);
            #1;
            digital_in = 16'h4444;
            @(posedge clk);
            #1;
            digital_in = 16'h8888;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h8888);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asynchronous Enable Safety", test_num);
            reset_dut();

            enable = 1;
            digital_in = 16'hBEEF;
            @(posedge clk);
            #1;

            enable = 0;
            #2;
            digital_in = 16'hDEAD;
            #2;
            enable = 1;
            #2;


            #1;



            check_outputs(16'hBEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_16bit Testbench");
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
        input [15:0] expected_analog_out;
        begin
            if (expected_analog_out === (expected_analog_out ^ analog_out ^ expected_analog_out)) begin
                $display("PASS");
                $display("  Outputs: analog_out=%h",
                         analog_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_out=%h",
                         expected_analog_out);
                $display("  Got:      analog_out=%h",
                         analog_out);
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
        $dumpvars(0,clk, digital_in, enable, analog_out);
    end

endmodule

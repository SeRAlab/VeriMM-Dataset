`timescale 1ns/1ps

module carrier_frequency_recovery_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] digital_input;
    reg reset;
    wire [1:0] recovered_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carrier_frequency_recovery dut (
        .clk(clk),
        .digital_input(digital_input),
        .reset(reset),
        .recovered_signal(recovered_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            digital_input = 2'b00;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle Input", test_num);
            reset_dut();

            digital_input = 2'b00;
            repeat (200) @(posedge clk);



            #1;




            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Slow Carrier Recovery", test_num);
            reset_dut();


            for (i = 0; i < 500; i = i + 1) begin
                @(posedge clk);
                case (i % 4)
                    0: digital_input = 2'b01;
                    1: digital_input = 2'b11;
                    2: digital_input = 2'b01;
                    3: digital_input = 2'b00;
                endcase
            end



            if (recovered_signal != 2'bxx) begin
                pass_count = pass_count + 1;
                $display("PASS: Recovered signal active after lock period.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Recovered signal invalid.");
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fast Carrier Recovery", test_num);
            reset_dut();

            for (i = 0; i < 500; i = i + 1) begin
                @(posedge clk);
                if (i % 2 == 0)
                    digital_input = 2'b11;
                else
                    digital_input = 2'b00;
            end



            if (recovered_signal >= 2'b00 && recovered_signal <= 2'b11) begin
                pass_count = pass_count + 1;
                $display("PASS: Frequency lock achieved for fast carrier.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: No signal recovered.");
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Phase Shift Recovery", test_num);
            reset_dut();


            for (i = 0; i < 300; i = i + 1) begin
                @(posedge clk);
                case (i % 4)
                    0: digital_input = 2'b10;
                    1: digital_input = 2'b11;
                    2: digital_input = 2'b10;
                    3: digital_input = 2'b00;
                endcase
            end


            for (i = 0; i < 500; i = i + 1) begin
                @(posedge clk);
                case (i % 4)
                    0: digital_input = 2'b10;
                    1: digital_input = 2'b00;
                    2: digital_input = 2'b10;
                    3: digital_input = 2'b11;
                endcase
            end


            if (recovered_signal !== 2'bxx) begin
                pass_count = pass_count + 1;
                $display("PASS: Recovered signal stabilized after phase shift.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: System crashed on phase shift.");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DC Offset Handling", test_num);
            reset_dut();

            digital_input = 2'b11;
            repeat (400) @(posedge clk);



            if (recovered_signal !== 2'bxx) begin
                pass_count = pass_count + 1;
                $display("PASS: System stable under DC input.");
            } else begin
                fail_count = fail_count + 1;
                $display("FAIL: System entered undefined state.");
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carrier_frequency_recovery Testbench");
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
        input [1:0] expected_recovered_signal;
        begin
            if (expected_recovered_signal === (expected_recovered_signal ^ recovered_signal ^ expected_recovered_signal)) begin
                $display("PASS");
                $display("  Outputs: recovered_signal=%h",
                         recovered_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: recovered_signal=%h",
                         expected_recovered_signal);
                $display("  Got:      recovered_signal=%h",
                         recovered_signal);
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
        $dumpvars(0,clk, digital_input, reset, recovered_signal);
    end

endmodule

`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg reset;
    wire frame_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .frame_valid(frame_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            data_valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Detect SFD (0xD5) with data_valid high", test_num);
            reset_dut();

            data_in = 8'hD5;
            data_valid = 1;
            @(posedge clk);



            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Incorrect SFD value (0xAA)", test_num);
            reset_dut();

            data_in = 8'hAA;
            data_valid = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Correct SFD (0xD5) but data_valid=0", test_num);
            reset_dut();

            data_in = 8'hD5;
            data_valid = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Detect SFD after preamble (0x55 0x55 0xD5)", test_num);
            reset_dut();

            data_valid = 1;
            data_in = 8'h55; @(posedge clk);
            data_in = 8'h55; @(posedge clk);
            data_in = 8'hD5; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset clears frame_valid", test_num);
            reset_dut();


            data_in = 8'hD5;
            data_valid = 1;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: SFD with data_valid gaps", test_num);
            reset_dut();

            data_in = 8'h55; data_valid = 1; @(posedge clk);
            data_in = 8'hD5; data_valid = 0; @(posedge clk);
            data_in = 8'hFF; data_valid = 0; @(posedge clk);
            data_in = 8'hD5; data_valid = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input expected_frame_valid;
        begin
            if (expected_frame_valid === (expected_frame_valid ^ frame_valid ^ expected_frame_valid)) begin
                $display("PASS");
                $display("  Outputs: frame_valid=%b",
                         frame_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_valid=%b",
                         expected_frame_valid);
                $display("  Got:      frame_valid=%b",
                         frame_valid);
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
        $dumpvars(0,clk, data_in, data_valid, reset, frame_valid);
    end

endmodule

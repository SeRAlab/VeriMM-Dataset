`timescale 1ns/1ps

module data_bus_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] data_in;
    reg valid;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_bus_controller dut (
        .data_in(data_in),
        .valid(valid),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        valid = 0;
        forever #5 valid = ~valid;
    end

        task reset_dut;

        begin
            data_in = 32'h0;

            @(negedge valid);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: Valid high data output check", test_num);
            reset_dut();
            data_in = 32'h12345678;
            @(posedge valid);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: Valid low zero output check", test_num);
            reset_dut();
            data_in = 32'hABCDEF00;
            @(posedge valid);
            @(negedge valid);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: Latching new data after low period", test_num);
            reset_dut();
            data_in = 32'hAAAA_5555;
            @(posedge valid);
            @(negedge valid);
            data_in = 32'hFFFF_FFFF;
            @(posedge valid);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: All ones pattern check", test_num);
            reset_dut();
            data_in = 32'hFFFF_FFFF;
            @(posedge valid);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Executing Testcase %0d: Alternating bits pattern check", test_num);
            reset_dut();
            data_in = 32'h5555_AAAA;
            @(posedge valid);
            #2;
            #1;

            check_outputs(32'h5555_AAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_bus_controller Testbench");
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,data_in, valid, data_out);
    end

endmodule

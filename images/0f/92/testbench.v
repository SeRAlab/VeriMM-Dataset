`timescale 1ns/1ps

module bluetooth_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] command;
    wire [2:0] response;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_controller dut (
        .clk(clk),
        .command(command),
        .response(response)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            command = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Command 0000", test_num);
            reset_dut();
            command = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Command 0001", test_num);
            reset_dut();
            command = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Command 0010", test_num);
            reset_dut();
            command = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Command 0011", test_num);
            reset_dut();
            command = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Command 0100", test_num);
            reset_dut();
            command = 4'b0100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Command 0101 (Default Case)", test_num);
            reset_dut();
            command = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Command 1010 (Default Case)", test_num);
            reset_dut();
            command = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Command 1111 (Default Case)", test_num);
            reset_dut();
            command = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_response;
        begin
            if (expected_response === (expected_response ^ response ^ expected_response)) begin
                $display("PASS");
                $display("  Outputs: response=%h",
                         response);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: response=%h",
                         expected_response);
                $display("  Got:      response=%h",
                         response);
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
        $dumpvars(0,clk, command, response);
    end

endmodule

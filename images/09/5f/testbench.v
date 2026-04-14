`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] command;
    wire [7:0] response;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .command(command),
        .response(response)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: NOP Command (0x0)", test_num);
        command = 4'h0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write Command (0x1)", test_num);
        command = 4'h1;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Read Command (0x2)", test_num);
        command = 4'h2;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Flush Command (0x4)", test_num);
        command = 4'h4;
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Identify Command (0x5)", test_num);
        command = 4'h5;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Shutdown Command (0xF)", test_num);
        command = 4'hF;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Invalid Command (0x9)", test_num);
        command = 4'h9;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_response;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule

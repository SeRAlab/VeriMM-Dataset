`timescale 1ns/1ps

module nvme_command_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] command;
    wire [2:0] command_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_decoder dut (
        .command(command),
        .command_type(command_type)
    );
    task testcase001;

    begin
        test_num = 1;
        command = 4'b0000;
        $display("Testcase %0d: Input Command = 4'b0000", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        command = 4'b0001;
        $display("Testcase %0d: Input Command = 4'b0001", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        command = 4'b0010;
        $display("Testcase %0d: Input Command = 4'b0010", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        command = 4'b0011;
        $display("Testcase %0d: Input Command = 4'b0011", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        command = 4'b0100;
        $display("Testcase %0d: Input Command = 4'b0100", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        command = 4'b0101;
        $display("Testcase %0d: Input Command = 4'b0101", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        command = 4'b0110;
        $display("Testcase %0d: Input Command = 4'b0110", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        command = 4'b0111;
        $display("Testcase %0d: Input Command = 4'b0111", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        command = 4'b1000;
        $display("Testcase %0d: Input Command = 4'b1000 (Invalid range start)", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        command = 4'b1011;
        $display("Testcase %0d: Input Command = 4'b1011 (Invalid range mid)", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        command = 4'b1111;
        $display("Testcase %0d: Input Command = 4'b1111 (Invalid range max)", test_num);
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
        $display("nvme_command_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [2:0] expected_command_type;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_command_type === (expected_command_type ^ command_type ^ expected_command_type)) begin
                $display("PASS");
                $display("  Outputs: command_type=%h",
                         command_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_type=%h",
                         expected_command_type);
                $display("  Got:      command_type=%h",
                         command_type);
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

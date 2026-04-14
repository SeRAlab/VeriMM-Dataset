`timescale 1ns/1ps

module nvme_command_register_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg [3:0] cmd_type;
    reg cmd_valid;
    reg rst;
    wire cmd_ready;
    wire [3:0] stored_address;
    wire [3:0] stored_cmd_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_register dut (
        .address(address),
        .clk(clk),
        .cmd_type(cmd_type),
        .cmd_valid(cmd_valid),
        .rst(rst),
        .cmd_ready(cmd_ready),
        .stored_address(stored_address),
        .stored_cmd_type(stored_cmd_type)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cmd_valid = 0;
            address = 0;
            cmd_type = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Store Read Command (Type 00) at Address 0xA", test_num);
            reset_dut();

            @(negedge clk);
            cmd_type = 4'b0000;
            address = 4'hA;
            cmd_valid = 1;

            @(posedge clk);
            #1;
            cmd_valid = 0;

            #1;


            check_outputs(1'b1, 4'hA, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Store Write Command (Type 01) at Address 0x5", test_num);
            reset_dut();

            @(negedge clk);
            cmd_type = 4'b0001;
            address = 4'h5;
            cmd_valid = 1;

            @(posedge clk);
            #1;
            cmd_valid = 0;

            #1;


            check_outputs(1'b1, 4'h5, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify gating (cmd_valid=0)", test_num);
            reset_dut();

            @(negedge clk);
            cmd_type = 4'b0000;
            address = 4'hF;
            cmd_valid = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive Command Updates", test_num);
            reset_dut();


            @(negedge clk);
            cmd_type = 4'b0000;
            address = 4'h1;
            cmd_valid = 1;
            @(posedge clk);


            @(negedge clk);
            cmd_type = 4'b0001;
            address = 4'hE;
            cmd_valid = 1;
            @(posedge clk);
            #1;
            cmd_valid = 0;


            #1;



            check_outputs(1'b1, 4'hE, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Address (0xF)", test_num);
            reset_dut();

            @(negedge clk);
            cmd_type = 4'b0001;
            address = 4'hF;
            cmd_valid = 1;

            @(posedge clk);
            #1;
            cmd_valid = 0;

            #1;


            check_outputs(1'b1, 4'hF, 4'b0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_register Testbench");
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
        input expected_cmd_ready;
        input [3:0] expected_stored_address;
        input [3:0] expected_stored_cmd_type;
        begin
            if (expected_cmd_ready === (expected_cmd_ready ^ cmd_ready ^ expected_cmd_ready) &&
                expected_stored_address === (expected_stored_address ^ stored_address ^ expected_stored_address) &&
                expected_stored_cmd_type === (expected_stored_cmd_type ^ stored_cmd_type ^ expected_stored_cmd_type)) begin
                $display("PASS");
                $display("  Outputs: cmd_ready=%b, stored_address=%h, stored_cmd_type=%h",
                         cmd_ready, stored_address, stored_cmd_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_ready=%b, stored_address=%h, stored_cmd_type=%h",
                         expected_cmd_ready, expected_stored_address, expected_stored_cmd_type);
                $display("  Got:      cmd_ready=%b, stored_address=%h, stored_cmd_type=%h",
                         cmd_ready, stored_address, stored_cmd_type);
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
        $dumpvars(0,address, clk, cmd_type, cmd_valid, rst, cmd_ready, stored_address, stored_cmd_type);
    end

endmodule

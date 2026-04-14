`timescale 1ns/1ps

module NVMe_Command_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] opcode;
    reg [3:0] tag;
    wire [7:0] stored_opcode;
    wire [3:0] stored_tag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NVMe_Command_Register dut (
        .clk(clk),
        .opcode(opcode),
        .tag(tag),
        .stored_opcode(stored_opcode),
        .stored_tag(stored_tag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        opcode = 8'h00;
        tag = 4'h0;


        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Standard Read Command", test_num);
        reset_dut();

        opcode = 8'h02;
        tag = 4'h1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h02, 4'h1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Standard Write Command", test_num);
        reset_dut();

        opcode = 8'h01;
        tag = 4'hE;

        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h01, 4'hE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Boundary Values", test_num);
        reset_dut();

        opcode = 8'hFF;
        tag = 4'hF;

        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFF, 4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Boundary Values", test_num);
        reset_dut();


        opcode = 8'hAA;
        tag = 4'h5;
        @(posedge clk);
        #1;

        opcode = 8'h00;
        tag = 4'h0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Successive Updates", test_num);
        reset_dut();


        opcode = 8'h55;
        tag = 4'hA;
        @(posedge clk);
        #1;


        opcode = 8'hCC;
        tag = 4'h3;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'hCC, 4'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input change without clock", test_num);
        reset_dut();

        opcode = 8'h11;
        tag = 4'h1;
        @(posedge clk);
        #2;

        opcode = 8'h22;
        tag = 4'h2;
        #2;


        #1;



        check_outputs(8'h11, 4'h1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NVMe_Command_Register Testbench");
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
        input [7:0] expected_stored_opcode;
        input [3:0] expected_stored_tag;
        begin
            if (expected_stored_opcode === (expected_stored_opcode ^ stored_opcode ^ expected_stored_opcode) &&
                expected_stored_tag === (expected_stored_tag ^ stored_tag ^ expected_stored_tag)) begin
                $display("PASS");
                $display("  Outputs: stored_opcode=%h, stored_tag=%h",
                         stored_opcode, stored_tag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_opcode=%h, stored_tag=%h",
                         expected_stored_opcode, expected_stored_tag);
                $display("  Got:      stored_opcode=%h, stored_tag=%h",
                         stored_opcode, stored_tag);
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
        $dumpvars(0,clk, opcode, tag, stored_opcode, stored_tag);
    end

endmodule

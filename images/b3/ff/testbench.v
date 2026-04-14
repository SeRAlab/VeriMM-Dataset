`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] RDaddr_i;
    reg [31:0] RDdata_i;
    reg [4:0] RSaddr_i;
    reg [4:0] RTaddr_i;
    reg RegWrite_i;
    reg clk_i;
    wire [31:0] RSdata_o;
    wire [31:0] RTdata_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RDaddr_i(RDaddr_i),
        .RDdata_i(RDdata_i),
        .RSaddr_i(RSaddr_i),
        .RTaddr_i(RTaddr_i),
        .RegWrite_i(RegWrite_i),
        .clk_i(clk_i),
        .RSdata_o(RSdata_o),
        .RTdata_o(RTdata_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            RDaddr_i = 5'b0;
            RDdata_i = 32'b0;
            RSaddr_i = 5'b0;
            RTaddr_i = 5'b0;
            RegWrite_i = 1'b0;
            @(posedge clk_i);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read (Reg 1)", test_num);


            RDaddr_i = 5'd1;
            RDdata_i = 32'hDEADBEEF;
            RegWrite_i = 1'b1;
            @(posedge clk_i);
            #2;
            RegWrite_i = 1'b0;


            RSaddr_i = 5'd1;
            RTaddr_i = 5'd1;
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Dual Port Read (Reg 5 and Reg 10)", test_num);


            RDaddr_i = 5'd5;
            RDdata_i = 32'hAAAA5555;
            RegWrite_i = 1'b1;
            @(posedge clk_i);
            #2;


            RDaddr_i = 5'd10;
            RDdata_i = 32'h12345678;
            RegWrite_i = 1'b1;
            @(posedge clk_i);
            #2;
            RegWrite_i = 1'b0;


            RSaddr_i = 5'd5;
            RTaddr_i = 5'd10;
            #2;

            #1;


            check_outputs(32'hAAAA5555, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Write Enable Verification", test_num);


            RDaddr_i = 5'd7;
            RDdata_i = 32'hCAFEBABE;
            RegWrite_i = 1'b1;
            @(posedge clk_i);
            #2;


            RDaddr_i = 5'd7;
            RDdata_i = 32'h00000000;
            RegWrite_i = 1'b0;
            @(posedge clk_i);
            #2;


            RSaddr_i = 5'd7;
            RTaddr_i = 5'd7;
            #2;


            #1;



            check_outputs(32'hCAFEBABE, 32'hCAFEBABE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Boundary Address (Reg 31)", test_num);

            RDaddr_i = 5'd31;
            RDdata_i = 32'hFFFFFFFF;
            RegWrite_i = 1'b1;
            @(posedge clk_i);
            #2;
            RegWrite_i = 1'b0;

            RSaddr_i = 5'd31;
            RTaddr_i = 5'd0;
            #2;



            #1;




            check_outputs(32'hFFFFFFFF, RTdata_o);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Value Overwriting", test_num);


            RDaddr_i = 5'd15;
            RDdata_i = 32'h11111111;
            RegWrite_i = 1'b1;
            @(posedge clk_i);
            #2;


            RDdata_i = 32'h22222222;
            @(posedge clk_i);
            #2;
            RegWrite_i = 1'b0;

            RSaddr_i = 5'd15;
            RTaddr_i = 5'd15;
            #2;

            #1;


            check_outputs(32'h22222222, 32'h22222222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_RSdata_o;
        input [31:0] expected_RTdata_o;
        begin
            if (expected_RSdata_o === (expected_RSdata_o ^ RSdata_o ^ expected_RSdata_o) &&
                expected_RTdata_o === (expected_RTdata_o ^ RTdata_o ^ expected_RTdata_o)) begin
                $display("PASS");
                $display("  Outputs: RSdata_o=%h, RTdata_o=%h",
                         RSdata_o, RTdata_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RSdata_o=%h, RTdata_o=%h",
                         expected_RSdata_o, expected_RTdata_o);
                $display("  Got:      RSdata_o=%h, RTdata_o=%h",
                         RSdata_o, RTdata_o);
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
        $dumpvars(0,RDaddr_i, RDdata_i, RSaddr_i, RTaddr_i, RegWrite_i, clk_i, RSdata_o, RTdata_o);
    end

endmodule

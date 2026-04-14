`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [19:0] I_DR;
    reg [2:0] I_Memtype;
    reg [15:0] I_Res;
    reg [1:0] I_WBtype;
    reg clk;
    reg [15:0] memdata;
    reg reset;
    reg stall;
    reg [5:0] state;
    wire [2:0] CC;
    wire [19:0] O_DR;
    wire [15:0] O_Res;
    wire [1:0] O_WBtype;
    wire inst_ld;
    wire [15:0] memaddr;
    wire memapply;
    wire [15:0] memdatawr;
    wire memtype;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_DR(I_DR),
        .I_Memtype(I_Memtype),
        .I_Res(I_Res),
        .I_WBtype(I_WBtype),
        .clk(clk),
        .memdata(memdata),
        .reset(reset),
        .stall(stall),
        .state(state),
        .CC(CC),
        .O_DR(O_DR),
        .O_Res(O_Res),
        .O_WBtype(O_WBtype),
        .inst_ld(inst_ld),
        .memaddr(memaddr),
        .memapply(memapply),
        .memdatawr(memdatawr),
        .memtype(memtype)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            stall = 0;
            state = 6'b0;
            I_DR = 20'b0;
            I_Memtype = 3'b0;
            I_Res = 16'b0;
            I_WBtype = 2'b0;
            memdata = 16'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset", test_num);
            reset_dut();


            #1;



            check_outputs(3'b010, 20'h0, 16'h0, 2'b0, 1'b0, 16'h0, 1'b0, 16'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Idle Pass-through", test_num);
            reset_dut();
            I_DR = 20'hABCDE;
            I_Res = 16'h1234;
            I_WBtype = 2'b01;
            I_Memtype = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010, 20'hABCDE, 16'h1234, 2'b01, 1'b0, 16'h0, 1'b0, 16'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Memory Read (LD)", test_num);
            reset_dut();
            I_DR = 20'h00001;
            I_Res = 16'h3000;
            I_Memtype = 3'b001;
            memdata = 16'h55AA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001, 20'h00001, 16'h55AA, 2'b0, 1'b0, 16'h3000, 1'b1, 16'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Memory Write (ST)", test_num);
            reset_dut();
            I_DR = 20'h07788;
            I_Res = 16'h4000;
            I_Memtype = 3'b010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b010, 20'h07788, 16'h4000, 2'b0, 1'b0, 16'h4000, 1'b1, 16'h7788, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: CC Negative", test_num);
            reset_dut();
            I_Memtype = 3'b001;
            I_Res = 16'h5000;
            memdata = 16'h8001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b100, 20'h0, 16'h8001, 2'b0, 1'b0, 16'h5000, 1'b1, 16'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Pipeline Stall", test_num);
            reset_dut();
            I_DR = 20'h12345;
            stall = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(3'b010, 20'h0, 16'h0, 2'b0, 1'b0, 16'h0, 1'b0, 16'h0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Instruction Load", test_num);
            reset_dut();
            I_Memtype = 3'b011;
            I_Res = 16'h1000;
            @(posedge clk);
            #1;

            if (inst_ld === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: inst_ld is high");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: inst_ld is low");
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
        $display("top_module Testbench");
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
        input [2:0] expected_CC;
        input [19:0] expected_O_DR;
        input [15:0] expected_O_Res;
        input [1:0] expected_O_WBtype;
        input expected_inst_ld;
        input [15:0] expected_memaddr;
        input expected_memapply;
        input [15:0] expected_memdatawr;
        input expected_memtype;
        begin
            if (expected_CC === (expected_CC ^ CC ^ expected_CC) &&
                expected_O_DR === (expected_O_DR ^ O_DR ^ expected_O_DR) &&
                expected_O_Res === (expected_O_Res ^ O_Res ^ expected_O_Res) &&
                expected_O_WBtype === (expected_O_WBtype ^ O_WBtype ^ expected_O_WBtype) &&
                expected_inst_ld === (expected_inst_ld ^ inst_ld ^ expected_inst_ld) &&
                expected_memaddr === (expected_memaddr ^ memaddr ^ expected_memaddr) &&
                expected_memapply === (expected_memapply ^ memapply ^ expected_memapply) &&
                expected_memdatawr === (expected_memdatawr ^ memdatawr ^ expected_memdatawr) &&
                expected_memtype === (expected_memtype ^ memtype ^ expected_memtype)) begin
                $display("PASS");
                $display("  Outputs: CC=%h, O_DR=%h, O_Res=%h, O_WBtype=%h, inst_ld=%b, memaddr=%h, memapply=%b, memdatawr=%h, memtype=%b",
                         CC, O_DR, O_Res, O_WBtype, inst_ld, memaddr, memapply, memdatawr, memtype);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CC=%h, O_DR=%h, O_Res=%h, O_WBtype=%h, inst_ld=%b, memaddr=%h, memapply=%b, memdatawr=%h, memtype=%b",
                         expected_CC, expected_O_DR, expected_O_Res, expected_O_WBtype, expected_inst_ld, expected_memaddr, expected_memapply, expected_memdatawr, expected_memtype);
                $display("  Got:      CC=%h, O_DR=%h, O_Res=%h, O_WBtype=%h, inst_ld=%b, memaddr=%h, memapply=%b, memdatawr=%h, memtype=%b",
                         CC, O_DR, O_Res, O_WBtype, inst_ld, memaddr, memapply, memdatawr, memtype);
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
        $dumpvars(0,I_DR, I_Memtype, I_Res, I_WBtype, clk, memdata, reset, stall, state, CC, O_DR, O_Res, O_WBtype, inst_ld, memaddr, memapply, memdatawr, memtype);
    end

endmodule

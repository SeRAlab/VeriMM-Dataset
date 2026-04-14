`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg CS;
    reg [15:0] D;
    reg RE;
    reg WE;
    reg [3:0] addr;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .CS(CS),
        .D(D),
        .RE(RE),
        .WE(WE),
        .addr(addr),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write and Read at Address 0x0", test_num);

        CS = 1; WE = 0; RE = 0; addr = 4'h0; D = 16'h0000;
        #10;


        CS = 0; WE = 1; RE = 0; addr = 4'h0; D = 16'hA5A5;
        #10;
        WE = 0; CS = 1;
        #10;


        CS = 0; RE = 1; WE = 0; addr = 4'h0;
        #10;
        #1;

        check_outputs(16'hA5A5);


        RE = 0; CS = 1;
        #10;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write and Read at Address 0xF", test_num);

        CS = 1; WE = 0; RE = 0; addr = 4'h0; D = 16'h0000;
        #10;


        CS = 0; WE = 1; RE = 0; addr = 4'hF; D = 16'h5A5A;
        #10;
        WE = 0; CS = 1;
        #10;


        CS = 0; RE = 1; WE = 0; addr = 4'hF;
        #10;
        #1;

        check_outputs(16'h5A5A);


        RE = 0; CS = 1;
        #10;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Test (RE over WE)", test_num);

        CS = 1; WE = 0; RE = 0; addr = 4'h5; D = 16'h0000;
        #10;


        CS = 0; WE = 1; RE = 0; addr = 4'h5; D = 16'h1111;
        #10;
        WE = 0; CS = 1;
        #10;



        CS = 0; RE = 1; WE = 1; addr = 4'h5; D = 16'h2222;
        #10;


        #1;



        check_outputs(16'h1111);


        WE = 0; RE = 0; CS = 1; #10;
        CS = 0; RE = 1; addr = 4'h5;
        #10;
        #1;

        check_outputs(16'h1111);

        RE = 0; CS = 1;
        #10;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Chip Select (CS) Write Disable Test", test_num);

        CS = 1; WE = 0; RE = 0; addr = 4'hA; D = 16'h0000;
        #10;


        CS = 0; WE = 1; RE = 0; addr = 4'hA; D = 16'hBBBB;
        #10;
        WE = 0; CS = 1;
        #10;


        CS = 1; WE = 1; RE = 0; addr = 4'hA; D = 16'hCCCC;
        #10;
        WE = 0;
        #10;


        CS = 0; RE = 1; addr = 4'hA;
        #10;
        #1;

        check_outputs(16'hBBBB);

        RE = 0; CS = 1;
        #10;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite Operation Test", test_num);

        CS = 1; WE = 0; RE = 0; addr = 4'h3;
        #10;


        CS = 0; WE = 1; addr = 4'h3; D = 16'h1234;
        #10;
        WE = 0;
        #10;


        WE = 1; D = 16'hFEDC;
        #10;
        WE = 0; CS = 1;
        #10;


        CS = 0; RE = 1; addr = 4'h3;
        #10;
        #1;

        check_outputs(16'hFEDC);

        RE = 0; CS = 1;
        #10;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [15:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
